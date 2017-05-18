require 'active_support/core_ext/hash/except'
require 'mikoshi/plan'

module Mikoshi
  class Plan
    class Service < Base
      TASK_DEFINITION_WITH_REVISION = %r{\A\S+:\d+\z}

      def initialize(yaml_path: nil, client: nil)
        super

        if @data[:service][:task_definition].match(TASK_DEFINITION_WITH_REVISION).nil?
          raise ArgumentError, 'task_definition should have revision by numerically.'
        end

        @data[:service].store :service_name, @data[:service][:service]
      end

      def create_service
        invoke_before_create_hooks

        resp = @client.create_service(@data[:service].except(:service))
      end

      def update_service
        invoke_before_update_hooks

        resp = @client.update_service(@data[:service].except(:service_name))
      end

      def deploy_service
        case operation
        when :create
          create_service
        when :update
          update_service
        end

        @client.wait_until(:services_stable, cluster: @data[:service][:cluster], services: [@data[:service][:service]]) do |w|
          w.max_attempts = 30
          w.delay        = 10
        end

        case operation
        when :create
          invoke_after_create_hooks
        when :update
          invoke_after_update_hooks
        end
      end

      private

      def operation
        if @operation
          @operation
        else
          resp = @client.describe_services(cluster: @data[:service][:cluster], services: [@data[:service][:service]])

          @operation ||=
            if resp.services.empty? || resp.services.first.status == 'INACTIVE'
              :create
            else
              :update
            end
        end
      end

      %w[before after].each do |step|
        %w[create update].each do |func|
          define_method "invoke_#{step}_#{func}_hooks" do
            invoke_hooks @data[:hooks]["#{step}_#{func}".to_sym] unless @data.dig(:hooks, "#{step}_#{func}".to_sym).nil?
          end
        end
      end
    end
  end
end
