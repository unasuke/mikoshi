# frozen_string_literal: true

require 'mikoshi/plan/task_definition'

RSpec.describe 'Mikoshi::Plan::TaskDefinition' do
  describe '#register_task_definition' do
    let(:task_def) do
      Mikoshi::Plan::TaskDefinition.new(
        yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb',
        client: client,
      )
    end

    context 'when a registration succeeds' do
      let(:client) { Aws::ECS::Client.new(stub_responses: true) }

      it 'should export env TASK_DEF_REVISION and invoke hooks' do
        expect { task_def.register_task_definition }.
          to output("before register\nafter register\n").to_stdout_from_any_process
        expect(ENV['TASK_DEF_REVISION']).to eq '0' # default stub response
      end
    end

    context 'when a registration fails' do
      let(:client) do
        Aws::ECS::Client.new(stub_responses: { register_task_definition: StandardError })
      end

      it do
        expect { task_def.register_task_definition }.
          to  raise_error(StandardError).
          and output("before register\nfailed\n").to_stdout_from_any_process
      end
    end
  end

  describe '#runtask' do
    let(:client) { Aws::ECS::Client.new(stub_responses: true) }
    let(:task_def) do
      Mikoshi::Plan::TaskDefinition.new(
        yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb',
        client: client,
      )
    end

    context 'when cluster is empty' do
      it 'should raise ArgumentError' do
        expect { task_def.runtask }.to raise_error(ArgumentError)
      end
    end

    context 'when cluster passed' do
      it 'should success' do
        expect(task_def.runtask(cluster: 'defailt')).to be
      end
    end
  end
end
