# frozen_string_literal: true

require 'active_support/core_ext/hash/except'

class Hash
  def except_keys(keys_enum)
    return dup.except!(keys_enum) unless keys_enum.respond_to?(:each)

    clone = dup
    keys_enum.each do |key|
      clone.except!(key)
    end

    clone
  end
end
