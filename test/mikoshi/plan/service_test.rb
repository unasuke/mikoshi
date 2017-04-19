require 'test_helper'

class MikoshiPlanServiceTest < MiniTest::Test
  def test_initialize_without_env
    assert_raises ArgumentError do
      ENV['TASK_REVISION'] = nil

      ::Mikoshi::Plan::Service.new(
        yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
        client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
      )
    end
  end

  def test_create_service
    require 'stub/create_service'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    resp = plan.create_service

    assert_equal resp.service.service_name, 'ping'
    assert_equal resp.service.task_definition, 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3'
    assert_equal resp.service.running_count, 0
  end

  def test_update_service
    require 'stub/update_service'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    resp = plan.update_service

    assert_equal resp.service.service_name, 'ping'
    assert_equal resp.service.task_definition, 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3'
    assert_equal resp.service.running_count, 1
  end

  def test_deploy_service_create
    require 'stub/describe_services_failuer'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    resp = plan.deploy_service

    assert_equal 'ping', resp.service.service_name
    assert_equal 0, resp.service.running_count
  end

  def test_deploy_service_update
    require 'stub/describe_services_active'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    resp = plan.deploy_service

    assert_equal 'ping', resp.service.service_name
    assert_equal 1, resp.service.running_count
  end

  def test_deployed_yet
    require 'stub/describe_services_deploying'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    assert_equal false, plan.deployed?
  end

  def test_deployed_done
    require 'stub/describe_services_active'
    ENV['TASK_REVISION'] = '3'

    plan = ::Mikoshi::Plan::Service.new(
      yaml_path: File.expand_path('../../../dummy/services/ping.yml.erb', __FILE__),
      client: Aws::ECS::Client.new(region: 'ap-northeast-1'),
    )

    assert_equal true, plan.deployed?
  end
end
