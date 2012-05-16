require 'bundler/setup'
require 'active_support/all'
require 'sinatra'

class Wedding < Sinatra::Base
  configure do
    enable :logging
    #require_relative "../config/redis_config"
  end

  set :public_folder, File.join(File.dirname(__FILE__), "public")

  get "/" do
    status 200
    headers 'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    body File.open(File.join(settings.public_folder, 'index.html'), File::RDONLY)
  end

  get "/photos" do
    redirect "http://photos.colinandlauren.us"
  end

end
