require 'time'
require 'aws-sdk'

Aws.config[:ecs] = {
  stub_responses: {
    describe_services: {
      services: [
      ],
      failures: [
        arn: 'arn:aws:ecs:ap-northeast-1:012345678910:service/ping',
        reason: 'MISSING',
      ],
    },
    create_service: {
      service: {
        cluster_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:cluster/ping',
        created_at: Time.parse('2017-04-18'),
        deployments: [],
        desired_count: 1,
        pending_count: 0,
        running_count: 0,
        service_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:service/ping',
        service_name: 'ping',
        status: 'ACTIVE',
        task_definition: 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3',
      },
    },
  },
}
