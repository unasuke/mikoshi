# frozen_string_literal: true

require 'aws-sdk'
require 'mikoshi/plan'
require 'mikoshi/plan/task_definition'
require 'mikoshi/plan/service'

module Mikoshi
  class Cli
    TASK_DEFINITION_PATH = 'task_definitions'
    SERVICE_PATH = 'services'
    PLAN_EXT = '.yml.erb'
    FETCH_INTERVAL = 10
    DEPLOY_TIMEOUT = 300
  end
end
