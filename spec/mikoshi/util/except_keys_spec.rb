# frozen_string_literal: true

require 'mikoshi/util/except_keys'

RSpec.describe 'Hash#except_keys' do
  let(:data) do
    {
      a: 'one',
      b: 'two',
      c: 'three',
    }
  end

  context 'pass single key' do
    it { expect(data.except_keys(:b)).to eq(a: 'one', c: 'three') }
  end

  context 'pass multiple keys with array' do
    it { expect(data.except_keys(%i[a b])).to eq(c: 'three') }
  end
end
