require 'active_support/core_ext/hash/except'
require 'mikoshi/plan'

module Mikoshi
  class Plan
    class Service < Base
      TASK_DEFINITION_WITH_REVISION = %r{\A\S+:\d+\z}

      def initialize(yaml_path: nil, client: nil)
        super

        if @data[:task_definition].match(TASK_DEFINITION_WITH_REVISION).nil?
          raise ArgumentError, 'task_definition should have revision by numerically.'
        end

        @data.store :service_name, @data[:service]
      end

      def create_service
        @client.create_service(@data.except(:service))
      end

      def update_service
        @client.update_service(@data.except(:service_name))
      end

      def deploy_service
        resp = @client.describe_services(cluster: @data[:cluster], services: [@data[:service]])
        if resp.services.empty? || resp.services.first.status == 'INACTIVE'
          create_service
        else
          update_service
        end
      end

      def deployed?
        resp = @client.describe_services(cluster: @data[:cluster], services: [@data[:service]])
        deployment = resp.services.first.deployments.find do |d|
          d.task_definition.end_with?(@data[:task_definition])
        end

        if deployment.running_count == @data[:desired_count]
          true
        else
          false
        end
      end
    end
  end
end
