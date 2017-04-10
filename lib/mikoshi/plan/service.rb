require 'active_support/core_ext/hash/except'
require 'mikoshi/plan'

module Mikoshi
  class Plan
    class Service < Base
      TASK_DEFINITION_WITH_REVISION = %r!\A\S+:\d+\z!

      def initialize(yaml_path: nil, client: nil)
        super

        @data.store :service_name, @data[:service]

        if @data[:task_definition].match(TASK_DEFINITION_WITH_REVISION).nil?
          raise ArgumentError, 'task_definition should have revison by numerically.'
        end
      end

      def create_service
        @client.create_service(@data.except(:service))
      end

      def update_service
        @client.update_service(@data.except(:service_name))
      end

      def deploy_service
        resp = @client.describe_services(cluster: @data[:cluster], services: [@data[:service]])
        if resp.services.first.status == "ACTIVE"
          update_service
        else
          create_service
        end
      end
    end
  end
end
