require 'aws-sdk'

module Mikoshi
  class Manager
    attr_reader :region, :client

    def initialize(region: 'ap-northeast-1')
      @region = region
      @client = Aws::ECS::Client.new(region: @region)
    end

    def register_task_definition(plan)
      @client.register_task_definition(plan.data)
    end
  end
end
