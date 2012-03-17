ENV['RACK_ENV'] = "test"
require_relative '../lib/wedding'

require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
end

