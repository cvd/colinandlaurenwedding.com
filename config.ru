ENV["RACK_ENV"] ||= "development"
require './lib/wedding'

puts "Rack Env: #{ENV["RACK_ENV"]}"
run Wed.new
