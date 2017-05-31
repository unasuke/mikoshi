# frozen_string_literal: true

require 'mikoshi/plan/service'

RSpec.describe 'Mikoshi::Plan::Service' do
  context '#initialize' do
    context 'task_definition revision is non numerically value' do
      let(:client) { Aws::ECS::Client.new(stub_responses: true) }

      it 'should raise ArgumentError' do
        ENV['TASK_DEF_REVISION'] = 'a'

        expect do
          Mikoshi::Plan::Service.new(
            yaml_path: 'spec/yaml/services/ping2googledns.yml.erb',
            client: client,
          )
        end.to raise_error(ArgumentError, 'task_definition should have revision by numerically.')
      end
    end

    context ':service and :service_name' do
      let(:client) { Aws::ECS::Client.new(stub_responses: true) }
      let(:service) do
        ENV['TASK_DEF_REVISION'] = '1'
        Mikoshi::Plan::Service.new(
          yaml_path: 'spec/yaml/services/ping2googledns.yml.erb',
          client: client,
        )
      end

      it { expect(service.data[:service]).to include(:service, :service_name) }
      it { expect(service.data[:service][:service]).to eq 'ping2googledns' }
      it { expect(service.data[:service][:service_name]).to eq 'ping2googledns' }
    end
  end

  context '#create_service' do
    let(:client) { Aws::ECS::Client.new(stub_responses: true) }
    let(:service) do
      ENV['TASK_DEF_REVISION'] = '1'
      Mikoshi::Plan::Service.new(
        yaml_path: 'spec/yaml/services/ping2googledns.yml.erb',
        client: client,
      )
    end

    it { expect { service.create_service }.to output("before create\n").to_stdout_from_any_process }
  end

  context '#update_service' do
    let(:client) { Aws::ECS::Client.new(stub_responses: true) }
    let(:service) do
      ENV['TASK_DEF_REVISION'] = '1'
      Mikoshi::Plan::Service.new(
        yaml_path: 'spec/yaml/services/ping2googledns.yml.erb',
        client: client,
      )
    end

    it { expect { service.update_service }.to output("before update\n").to_stdout_from_any_process }
  end

  context '#deploy_service' do
    let(:service) do
      ENV['TASK_DEF_REVISION'] = '1'
      Mikoshi::Plan::Service.new(
        yaml_path: 'spec/yaml/services/ping2googledns.yml.erb',
        client: client,
      )
    end

    context 'when create' do
      let(:client) do
        Aws::ECS::Client.new(
          stub_responses: {
            describe_services: {
              services: [],
            },
          },
        )
      end
      it { expect { service.deploy_service }.to output("before create\nafter create\n").to_stdout_from_any_process }
    end

    context 'when update' do
      let(:client) do
        Aws::ECS::Client.new(
          stub_responses: {
            describe_services: {
              services: [
                service_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:service/ping2googledns',
                service_name: 'ping2googledns',
                cluster_arn: 'arn:aws:ecs:ap-northeast-1:012345678910:cluster/default',
                status: 'ACTIVE',
                deployments: [],
                desired_count: 1,
                pending_count: 0,
                running_count: 1,
                task_definition: 'arn:aws:ecs:ap-northeast-1:012345678910:task-definition/ping2googledns:1',
              ],
            },
          },
        )
      end
      it 'should invoke update hooks' do
        allow(client).to receive(:wait_until).and_return(true)
        expect { service.deploy_service }.to output("before update\nafter update\n").to_stdout_from_any_process
      end
    end

    context 'when a deployment fails' do
      let(:client) do
        Aws::ECS::Client.new(
          stub_responses: {
            describe_services: { services: [] },
            create_service: StandardError,
          },
        )
      end
      it do
        expect { service.deploy_service }.
          to  raise_error(StandardError).
          and output("before create\nfailed\n").to_stdout_from_any_process
      end
    end
  end
end
