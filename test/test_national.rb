# frozen_string_literal: true

require 'set'
require 'bundler/setup'
require_relative '../lib/redfin_as_dataframe'

failures = []
failures << 'version' if RedfinAsDataframe::VERSION.to_s.empty?
nat = RedfinAsDataframe::National.new
failures << 'instantiate' unless nat.is_a?(RedfinAsDataframe::National)
failures << 'fetch' unless nat.respond_to?(:fetch)

if failures.empty?
  puts 'test_national: ok'
else
  abort "test_national failed: #{failures.join(', ')}"
end
