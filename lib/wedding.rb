require 'bundler/setup'
require 'active_support/all'
require 'redis'
require 'sinatra'
require 'uuidtools'
require 'tempfile'
require 'aws/s3'
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
    begin
      email = ParseEmail.new(params)
      email.create_files
      return 200
    rescue
      puts $!.inspect
      puts $!.backtrace[0..5].join("\n")
      return 500
    end
  end

  get "*" do
    puts "Catchall"
    puts params
  end

end
