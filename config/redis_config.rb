
env = ENV.fetch("RACK_ENV")

case env
when "production"
  uri = ENV.fetch("REDISTOGO_URL")
  uri = URI.parse(uri)
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
when "development"
  $redis = Redis.new
  $redis.select(2)
else
  $redis = Redis.new
  $redis.select(5)
end
