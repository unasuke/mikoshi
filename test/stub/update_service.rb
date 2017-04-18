require 'time'
require 'aws-sdk'

Aws.config[:ecs] = {
  stub_responses: {
    update_service: {
      service: {
        service_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:service/ping',
        cluster_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:cluster/ping',
        created_at: Time.parse('2017-04-18'),
        deployments: [],
        desired_count: 1,
        pending_count: 0,
        running_count: 1,
        service_name: 'ping',
        status: 'ACTIVE',
        task_definition: 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3',
      },
    },
  },
}
