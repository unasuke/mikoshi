# frozen_string_literal: true

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
      rescue => e
        invoke_failed_hooks
        raise e
      end

      def runtask(cluster: nil)
        raise ArgumentError, 'cluster name is required.' if cluster.nil?

        resp = @client.run_task(task_definition: @data[:task_definition][:family], cluster: cluster)
      end

      private

      %w[before after].each do |step|
        define_method "invoke_#{step}_register_hooks" do
          invoke_hooks @data[:hooks]["#{step}_register".to_sym] unless @data.dig(:hooks, "#{step}_register".to_sym).nil?
        end
      end
      def invoke_failed_hooks
        invoke_hooks(@data[:hooks][:failed]) unless @data.dig(:hooks, :failed).nil?
      end
    end
  end
end
