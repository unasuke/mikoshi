require 'erb'
require 'hashie'
require 'yaml'

module Mikoshi
  class Plan
    class Base
      attr_reader :data, :client

      def initialize(yaml_path: nil, client: nil)
        raise ArgumentError, 'Yaml file path is required.' if yaml_path.nil?

        @data = Hashie::Mash.new(YAML.safe_load(ERB.new(File.new(yaml_path).read).result))
        @client = client
      end
    end
  end
end
