require 'test_helper'

class MikoshiPlanTest < MiniTest::Test
  def test_initialize_without_yaml_path
    assert_raises ArgumentError do
      ::Mikoshi::Plan::Base.new(client: Aws::ECS::Client.new(region: 'ap-northeast-1'))
    end
  end

  def test_initialize_without_client
    assert_raises ArgumentError do
      ::Mikoshi::Plan::Base.new(yaml_path: 'dummy/yaml.yml')
    end
  end

  def test_initialize
    plan = ::Mikoshi::Plan::Base.new(
      yaml_path: File.expand_path('../../dummy/task_definitions/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )
    assert plan.data.is_a?(Hash)
  end
end
