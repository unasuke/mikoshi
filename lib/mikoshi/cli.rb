# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/ClassLength

require 'aws-sdk-ecs'
require 'mikoshi/plan'
require 'mikoshi/plan/task_definition'
require 'mikoshi/plan/service'
require 'optparse'

module Mikoshi
  class Cli
    attr_reader :options

    TASK_DEFINITION_PATH = 'task_definitions'
    SERVICE_PATH = 'services'
    PLAN_EXT = '.yml.erb'
    FETCH_INTERVAL = 10
    DEPLOY_TIMEOUT = 300

    def initialize(argv: nil)
      raise ArgumentError, 'argv is required.' if argv.nil?

      @argv = argv
      @options = { region: nil, command: nil, config: {} }
    end

    def start
      parse
      exit_when_flag

      case @options[:command]
      when :update_task_definition
        update_task_definition(@options[:config][:task_definition] || @argv[1])
      when :update_service
        update_service(@options[:config][:service] || @argv[1])
      when :runtask
        runtask(@options[:config][:task_definition] || @argv[1], @options[:config][:cluster])
      when :deploy
        deploy
      when :version
        version
      when :help
        usage
      else
        command_is_unkown(command: @options[:command])
      end
    end

    def parse
      opt = OptionParser.new

      opt.on('-r', '--region=REGION')                   { |v| @options[:region] = v }
      opt.on('-s', '--service=SERVICE')                 { |v| @options[:config][:service] = v }
      opt.on('-t', '--task-definition=TASK_DEFINITION') { |v| @options[:config][:task_definition] = v }
      opt.on('--potdr')                                 { |v| @options[:config][:potdr] = v }
      opt.on('-g', '--group=GROUP')                     { |v| @options[:config][:group] = v }
      opt.on('-h', '--help')                            { |v| @options[:config][:help] = v }
      opt.on('-v', '--version')                         { |v| @options[:config][:version] = v }
      opt.on('--cluster=CLUSTER')                       { |v| @options[:config][:cluster] = v }

      opt.permute!(@argv)
      @options[:command] = @argv.first.to_sym unless @argv.first.nil?
    end

    def exit_when_flag
      usage if @options[:config][:help]
      version if @options[:config][:version]
      exit if @options[:config][:help] || @options[:config][:version]
    end

    def usage
      puts <<~USAGE
        Usage of the mikoshi

        Global option
          -r, --region=REGION : Set aws region
          -h, --help          : Print this help message
          -v, --version       : Print mikoshi version

        Subcommands
          update_task_definition
            Update task definition to given task definition yaml file.
            Set TASK_DEF_REVISION to updated task definition revision number.

            Option
              --potdr
                Acronym of the "Print Only Task Definition Revision".

          runtask
            Invoke new task using specified task definition.

            Option
              --cluster
                Set cluster to run task. (required)

          update_service
            Update service to given service yaml file.
            Wait for success to update the service. (Maximum 300 min)

          deploy
            invoke update_task_definition and update_service.

            Option
              -g, --group=GROUP
                If task definition file name and service file name are
                same, that a shorthand of pass both.

          Common options
            -s, --service=SERVICE
            -t, --task-definition=TASK_DEFINITION
      USAGE
    end

    def version
      puts "mikoshi version #{Mikoshi::VERSION}"
    end

    def update_task_definition(task_def_name)
      if task_def_name.nil?
        warn '--task-definition=TASK_DEFINITION is require option.'
        abort
      end

      task = ::Mikoshi::Plan::TaskDefinition.new(
        yaml_path: File.join(TASK_DEFINITION_PATH, task_def_name + PLAN_EXT),
        client:    aws_client,
      )

      # print only task definition revision
      potdr = @options[:config][:potdr]

      puts "Update task definition: #{task_def_name}" unless potdr
      task.register_task_definition
      puts "Done update task definition: #{task_def_name} revision: #{ENV['TASK_DEF_REVISION']}" unless potdr
      puts ENV['TASK_DEF_REVISION'] if potdr
    end

    def runtask(task_def_name, cluster)
      if task_def_name.nil?
        warn '--task-definition=TASK_DEFINITION is require option.'
        abort
      end

      task = ::Mikoshi::Plan::TaskDefinition.new(
        yaml_path: File.join(TASK_DEFINITION_PATH, task_def_name + PLAN_EXT),
        client:    aws_client,
      )

      puts "Run task: #{task_def_name}"
      task.runtask(cluster: cluster)
      puts "Invoked task: #{task_def_name}"
    end

    def update_service(service_name)
      if service_name.nil?
        warn '--service=SERVICE is require option.'
        abort
      end

      service = ::Mikoshi::Plan::Service.new(
        yaml_path: File.join(SERVICE_PATH, service_name + PLAN_EXT),
        client:    aws_client,
      )

      puts "Update service: #{service_name}"
      service.deploy_service(message: true)
      puts "Done update service #{service_name}"
    end

    def deploy
      task_def_name = @options[:config][:group] || @options[:config][:task_definition]
      service_name = @options[:config][:group] || @options[:config][:service]

      update_task_definition(task_def_name) if task_def_name
      update_service(service_name) if service_name
    end

    def command_is_unkown(command: nil)
      warn "'#{command}' is unknown command. Please see help by `mikoshi help`."
    end

    def aws_client
      opt =
        if @options[:region].nil?
          {}
        else
          { region: @options[:region] }
        end
      Aws::ECS::Client.new(opt)
    end
  end
end

# rubocop: enable all
