require 'mikoshi/plan'

module Mikoshi
  class Plan
    class TaskDefinition < Base
      def initialize(yaml_path: nil, client: nil)
        super
      end

      def register_task_definition
        resp = @client.register_task_definition(@data)
        ENV['TASK_REVISION'] = resp.tas_definition.revision.to_s
        resp
      end
    end
  end
end
