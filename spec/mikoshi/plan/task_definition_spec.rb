# frozen_string_literal: true

require 'mikoshi/plan/task_definition'

RSpec.describe 'Mikoshi::Plan::TaskDefinition' do
  context '#register_task_definition' do
    let(:client) { Aws::ECS::Client.new(stub_responses: true) }
    let(:task_def) do
      Mikoshi::Plan::TaskDefinition.new(
        yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb',
        client: client,
      )
    end

    it { expect { task_def.register_task_definition }.to output("before register\nafter register\n").to_stdout_from_any_process }
    it "should export env 'TASK_DEF_REVISION'" do
      task_def.register_task_definition

      # default stub response
      expect(ENV['TASK_DEF_REVISION']).to eq '0'
    end
  end
end
