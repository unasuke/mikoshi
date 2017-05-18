require 'mikoshi/plan'

module Mikoshi
  class Plan
    class TaskDefinition < Base
      def initialize(yaml_path: nil, client: nil)
        super
      end

      def register_task_definition
        invoke_before_register_hooks

        resp = @client.register_task_definition(@data[:task_definition])
        ENV['TASK_DEF_REVISION'] = resp.task_definition.revision.to_s

        invoke_after_register_hooks

        resp
      end

      private

      def invoke_before_register_hooks
        invoke_hooks @data[:hooks][:before_register] unless @data.dig(:hooks, :before_register).nil?
      end

      def invoke_after_register_hooks
        invoke_hooks @data[:hooks][:after_register] unless @data.dig(:hooks, :after_register).nil?
      end
    end
  end
end
