require 'aws-sdk'

Aws.config[:ecs] = {
  stub_responses: {
    register_task_definition: {
      task_definition: {
        container_definitions: [
          {
            name: 'ping',
            command: [
              'ping',
              '8.8.8.8',
            ],
            cpu: 10,
            environment: [
            ],
            essential: true,
            image: 'unasuke/ping:latest',
            memory: 128,
            mount_points: [
            ],
            port_mappings: [
            ],
            volumes_from: [
            ],
          },
        ],
        family: 'ping',
        revision: 3,
        task_definition_arn: 'arn:aws:ecs:ap-northeast-1:1234567890:task-definition/ping:3',
        volumes: [
        ],
      },
    },
  },
}
