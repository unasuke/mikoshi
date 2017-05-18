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

      %w[before after].each do |step|
        define_method "invoke_#{step}_register_hooks" do
          invoke_hooks @data[:hooks]["#{step}_register".to_sym] unless @data.dig(:hooks, "#{step}_register".to_sym).nil?
        end
      end
    end
  end
end
