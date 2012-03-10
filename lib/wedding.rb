require 'bundler/setup'
require 'active_support/all'
require 'redis'
require 'sinatra'
require 'uuidtools'
require 'tempfile'
require_relative "./models/photo"
require_relative "./models/attachment"
require_relative "./models/parse_email"
require_relative "./models/s3_uploader"

class Wedding < Sinatra::Base
  configure do
    enable :logging
    #require_relative "../config/redis_config"
  end

  set :public_folder, File.join(File.dirname(__FILE__), "public")

  get "/" do
    puts settings.public_folder
    status 200
    headers 'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    body File.open(File.join(settings.public_folder, 'index.html'), File::RDONLY)
  end

  post "/receive_email" do
    puts "incoming email!!!"
    puts params.inspect
    puts params.to_yaml
  end

  get "/receive_email" do
    puts "incoming email!!!"
    puts params.inspect
  end

  get "*" do
    puts "Catchall"
    puts params
  end

end
