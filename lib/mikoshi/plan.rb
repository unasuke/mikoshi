require 'erb'
require 'yaml'

module Mikoshi
  class Plan
    attr_reader :data

    def initialize(yaml_path: nil)
      raise ArgumentError, 'Yaml file path is required.' if yaml_path.nil?

      @data = YAML.safe_load(ERB.new(File.new(yaml_path).read).result)
    end
  end
end
