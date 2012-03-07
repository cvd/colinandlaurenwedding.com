ENV["RACK_ENV"] ||= "development"
require './lib/wedding'

run Wedding.new
