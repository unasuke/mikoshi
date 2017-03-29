require 'thor'

module Mikoshi
  class Cli < Thor
    desc 'update_task TASK_NAME', 'Update task definition'
    def update_task(task_name)
      puts task_name
    end

    desc 'sync_all_tasks', 'Create task definitions that not yet uploaded'
    def sync_all_tasks
    end

    desc 'deploy TASK_NAME', 'Deploy task definition'
    def deploy(task_name)
      puts task_name
    end
  end
end
