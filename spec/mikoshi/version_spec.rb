# frozen_string_literal: true

require 'mikoshi/version'

RSpec.describe 'Mikoshi::VERSION' do
  it { expect(Mikoshi::VERSION).not_to be_empty }
end
