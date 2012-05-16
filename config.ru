require './lib/wedding'

run Rack::URLMap.new "/" => Wedding.new,
