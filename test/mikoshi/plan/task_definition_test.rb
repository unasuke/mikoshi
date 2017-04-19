require 'test_helper'
require 'stub/register_task_definition'

class MikoshiPlanTaskDefinitionTest < MiniTest::Test
  def test_register_task_definition
    plan = ::Mikoshi::Plan::TaskDefinition.new(
      yaml_path: File.expand_path('../../../dummy/task_definitions/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    plan.register_task_definition

    assert_equal ENV['TASK_REVISION'], '3'
  end
end
