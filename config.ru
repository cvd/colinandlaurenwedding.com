require './lib/wedding'
require 'resque/server'

run Rack::URLMap.new \
  "/"       => Wedding.new,
  "/resque" => Resque::Server.new
