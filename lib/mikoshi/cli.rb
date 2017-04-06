require 'thor'
require 'aws-sdk'

module Mikoshi
  class Cli < Thor
    desc 'update_task TASK_NAME', 'Update task definition'
    def update_task(task_name)
      puts task_name
    end

    desc 'deploy TASK_NAME', 'Deploy task definition'
    def deploy(task_name)
      puts task_name
    end

    no_tasks do
      def aws_client
        if ENV['AWS_REGION'].nil? && options[:region].nil?
          raise ArgumentError, 'aws region is required'
        end
        region = ENV['AWS_REGION']
        region = options[:region] unless options[:region].nil?

        Aws::ECS::Client.new(region: region)
      end
    end
  end
end
