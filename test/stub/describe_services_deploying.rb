require 'time'
require 'aws-sdk'

Aws.config[:ecs] = {
  stub_responses: {
    describe_services: {
      services: [
        {
          cluster_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:cluster/ping',
          created_at: Time.parse('2017-04-18'),
          deployment_configuration: {
            maximum_percent: 200,
            minimum_healthy_percent: 100,
          },
          deployments: [
            {
              created_at: Time.parse('2017-04-18'),
              desired_count: 1,
              id: 'ecs-svc/1234567890',
              pending_count: 0,
              running_count: 0,
              status: 'ACTIVE',
              task_definition: 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3',
              updated_at: Time.parse('2017-04-18'),
            },
          ],
          desired_count: 1,
          pending_count: 0,
          running_count: 1,
          events: [],
          service_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:service/ping',
          service_name: 'ping',
          status: 'ACTIVE',
          task_definition: 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping:3',
        },
      ],
    },
  },
}
