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
        @client.create_service(@data[:service].except(:service))
      end

      def update_service
        @client.update_service(@data[:service].except(:service_name))
      end

      def deploy_service
        resp = @client.describe_services(cluster: @data[:service][:cluster], services: [@data[:service][:service]])
        if resp.services.empty? || resp.services.first.status == 'INACTIVE'
          create_service
        else
          update_service
        end
      end

      def deployed?
        resp = @client.describe_services(cluster: @data[:service][:cluster], services: [@data[:service][:service]])
        deployment = resp.services.first.deployments.find do |d|
          d.task_definition.end_with?(@data[:service][:task_definition])
        end

        if deployment.running_count == @data[:service][:desired_count]
          true
        else
          false
        end
      end
    end
  end
end
