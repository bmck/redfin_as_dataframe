require 'bundler/setup'
require 'redfin_as_dataframe'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Disable WebMock to prevent real HTTP connections during tests
  WebMock.disable_net_connect!(allow_localhost: true)
end
