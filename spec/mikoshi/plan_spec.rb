# frozen_string_literal: true

require 'mikoshi/plan'

RSpec.describe 'Mikoshi::Plan::Base' do
  context '#initialize' do
    context 'enough arguments' do
      let(:client) { Aws::ECS::Client.new(stub_responses: true) }
      let(:plan) do
        Mikoshi::Plan::Base.new(yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb', client: client)
      end

      it { expect(plan).to be_instance_of(Mikoshi::Plan::Base) }
    end

    context 'lack yaml' do
      let(:client) { Aws::ECS::Client.new(stub_responses: true) }

      it 'should raise ArgumentError' do
        expect do
          Mikoshi::Plan::Base.new(client: client)
        end.to raise_error(ArgumentError, 'Yaml file path is required.')
      end
    end

    context 'lack client' do
      it 'should raise ArgumentError' do
        expect do
          Mikoshi::Plan::Base.new(yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb')
        end.to raise_error(ArgumentError, 'client is required.')
      end
    end
  end

  describe '#invoke_hooks' do
    let(:client) { Aws::ECS::Client.new(stub_responses: true) }
    let(:plan) do
      Mikoshi::Plan::Base.new(yaml_path: 'spec/yaml/task_definitions/ping2googledns.yml.erb', client: client)
    end

    subject do
      -> { plan.invoke_hooks(commands) }
    end

    context 'when hook execution succeeds' do
      let(:commands) { ['echo hello'] }
      it { is_expected.to output("hello\n").to_stdout_from_any_process }
    end

    context 'when hook execution fails' do
      let(:commands) { ['false'] }
      it { is_expected.to raise_error Mikoshi::HookExecutionError }
    end
  end
end
