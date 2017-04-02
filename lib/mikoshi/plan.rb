require 'active_support/core_ext/hash/keys'
require 'erb'
require 'yaml'

module Mikoshi
  class Plan
    class Base
      attr_reader :data, :client

      def initialize(yaml_path: nil, client: nil)
        raise ArgumentError, 'Yaml file path is required.' if yaml_path.nil?

        @data = YAML.safe_load(ERB.new(File.new(yaml_path).read).result).symbolize_keys
        @client = client
      end
    end
  end
end
