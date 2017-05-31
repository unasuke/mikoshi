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

      it do
        expect { task_def.register_task_definition }.
          to output("before register\nafter register\n").to_stdout_from_any_process
      end
      it "should export env 'TASK_DEF_REVISION'" do
        task_def.register_task_definition
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
end
