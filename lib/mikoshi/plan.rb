# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'erb'
require 'yaml'

module Mikoshi
  HookExecutionError = Class.new(StandardError)

  class Plan
    class Base
      attr_reader :data, :client

      def initialize(yaml_path: nil, client: nil)
        raise ArgumentError, 'Yaml file path is required.' if yaml_path.nil?
        raise ArgumentError, 'client is required.' if client.nil?

        @data = YAML.safe_load(ERB.new(File.new(yaml_path).read).result).deep_symbolize_keys
        @client = client
      end

      def invoke_hooks(hooks)
        hooks.each do |hook|
          raise(HookExecutionError, hook) unless system(hook)
        end
      end
    end
  end
end
