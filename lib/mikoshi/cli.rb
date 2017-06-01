# frozen_string_literal: true

require 'thor'
require 'aws-sdk'
require 'mikoshi/plan'
require 'mikoshi/plan/task_definition'
require 'mikoshi/plan/service'

module Mikoshi
  class Cli < Thor
    TASK_DEFINITION_PATH = 'task_definitions'
    SERVICE_PATH = 'services'
    PLAN_EXT = '.yml.erb'
    FETCH_INTERVAL = 10
    DEPLOY_TIMEOUT = 300

    class_option :region, type: :string, desc: 'aws region'

    desc 'update_task TASK_NAME', 'Update task definition'
    def update_task_definition(task_name)
      task = ::Mikoshi::Plan::TaskDefinition.new(
        yaml_path:  File.join(TASK_DEFINITION_PATH, task_name + PLAN_EXT),
        client:     aws_client,
      )
      puts "Update task definition: #{task_name}"
      task.register_task_definition
      puts "Done update task definition: #{task_name} revision: #{ENV['TASK_DEF_REVISION']}"
    end

    desc 'update_service SERVICE_NAME', 'Update service'
    def update_service(service_name)
      service = ::Mikoshi::Plan::Service.new(
        yaml_path:  File.join(SERVICE_PATH, service_name + PLAN_EXT),
        client:     aws_client,
      )
      puts "Update service : #{service_name}"
      service.deploy_service(message: true)
      puts "Done update service #{service_name}"
    end

    desc 'deploy', 'Deploy task definition and service'
    method_option :task_definition, type: :string, desc: 'task_definition name', aliases: '-t'
    method_option :service, type: :string, desc: 'service name', aliases: '-s'
    method_option :group, type: :string, desc: 'service and task definition name(if both are same)', aliases: '-g'

    def deploy
      task_definition = options[:group] || options[:task_definition] || nil
      service = options[:group] || options[:service] || nil

      update_task_definition(task_definition) if task_definition
      update_service(service) if service
    end

    no_tasks do
      def aws_client
        opt =
          if options[:region].nil?
            {}
          else
            { region: options[:region] }
          end

        Aws::ECS::Client.new(opt)
      end
    end
  end
end
