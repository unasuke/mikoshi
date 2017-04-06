require 'active_support/core_ext/hash/except'
require 'mikoshi/plan'

module Mikoshi
  class Plan
    class Service < Base
      def initialize(yaml_path: nil, client: nil)
        super

        @data.store :service_name, @data[:service]
      end

      def create_service
        @client.create_service(@data.except(:service))
      end

      def update_service
        @client.update_service(@data.except(:service_name))
      end
    end
  end
end
