# frozen_string_literal: true

require 'mikoshi/cli'

RSpec.describe 'Mikoshi::Cli' do
  describe '#parse' do
    let(:cli) { ::Mikoshi::Cli.new(argv: argv) }

    context 'global options' do
      let(:argv) { %w[--help --region=ap-northeast-1 --version] }

      it 'should parse successfly' do
        cli.parse

        expect(cli.options[:region]).to eq 'ap-northeast-1'
        expect(cli.options[:config][:help]).to be_truthy
        expect(cli.options[:config][:version]).to be_truthy
      end
    end

    context 'subcommand' do
      let(:argv) { %w[update_task_definition] }

      it 'should parse subcommand successfly' do
        cli.parse

        expect(cli.options[:command]).to eq :update_task_definition
      end
    end
  end

  describe '#usage' do
    let(:cli) { ::Mikoshi::Cli.new(argv: []) }
    specify { expect { cli.usage }.to output.to_stdout }
  end

  describe '#version' do
    let(:cli) { ::Mikoshi::Cli.new(argv: []) }
    specify { expect { cli.version }.to output.to_stdout }
  end
end
