require 'thor'
require 'aws-sdk'
require 'mikoshi/plan'
require 'mikoshi/plan/task_definition'
require 'mikoshi/plan/service'

module Mikoshi
  class Cli < Thor
    TASK_DEFINITION_PATH = 'task_definitions'.freeze
    SERVICE_PATH = 'services'.freeze
    PLAN_EXT = '.yml.erb'.freeze

    class_option :region, type: :string, desc: 'aws region'

    desc 'update_task TASK_NAME', 'Update task definition'
    def update_task_definition(task_name)
      task = ::Mikoshi::Plan::TaskDefinition.new(
        yaml_path:  File.join(TASK_DEFINITION_PATH, task_name + PLAN_EXT),
        client:     aws_client
      )
      puts "Update task definition: #{task_name}"
      task.register_task_definition
      puts "Done update task definition: #{task_name} revison: #{ENV['TASK_REVISION']}"
    end

    desc 'deploy TASK_NAME', 'Deploy task definition'
    def deploy(task_name)
      puts task_name
    end

    no_tasks do
      def aws_client
        opt =
          if options[:region].nil?
            {}
          else
            {region: options[:region]}
          end

        Aws::ECS::Client.new(opt)
      end
    end
  end
end
