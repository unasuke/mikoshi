# frozen_string_literal: true

require 'mikoshi/plan'
require 'mikoshi/util/except_keys'

module Mikoshi
  class Plan
    class Service < Base
      TASK_DEFINITION_WITH_REVISION = %r{\A\S+:\d+\z}
      IGNORE_OPTIONS_WHEN_UPDATE =
        %i[client_token load_balancers placement_constraints placement_strategy role service_name].freeze

      def initialize(yaml_path: nil, client: nil)
        super

        if @data[:service][:task_definition].match(TASK_DEFINITION_WITH_REVISION).nil?
          raise ArgumentError, 'task_definition should have revision by numerically.'
        end

        @data[:service].store :service_name, @data[:service][:service]
      end

      def create_service
        invoke_before_create_hooks

        @client.create_service(@data[:service].except(:service))
        wait_until_services_stable

        invoke_after_create_hooks
      end

      def update_service
        invoke_before_update_hooks

        @client.update_service(@data[:service].except_keys(IGNORE_OPTIONS_WHEN_UPDATE))
        wait_until_services_stable

        invoke_after_update_hooks
      end

      def deploy_service(message: false)
        @message = message

        case operation
        when :create
          create_service
        when :update
          update_service
        end
      rescue => e
        invoke_failed_hooks
        raise e
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

      def wait_until_services_stable
        params = { cluster: @data[:service][:cluster], services: [@data[:service][:service]] }

        @client.wait_until(:services_stable, params) do |w|
          w.max_attempts = 30
          w.delay        = 10

          w.before_wait do
            puts 'Waiting to change status of service...' if @message
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
      def invoke_failed_hooks
        invoke_hooks(@data[:hooks][:failed]) unless @data.dig(:hooks, :failed).nil?
      end
    end
  end
end
