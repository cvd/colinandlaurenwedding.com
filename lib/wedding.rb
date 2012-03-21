require 'bundler/setup'
require 'active_support/all'
require 'redis'
require 'sinatra'
require 'uuidtools'
require 'tempfile'
require 'aws/s3'
require 'exifr'
require 'RMagick'
require 'resque'

require_relative "./models/photo"
require_relative "./models/attachment"
require_relative "./models/parse_email"
require_relative "./models/s3_uploader"

ENV["RACK_ENV"] ||= "development"
case ENV["RACK_ENV"].downcase
when "production"
  FILE_DIR = "/app/tmp"
when "development"
  FILE_DIR = File.join(File.dirname(__FILE__), "..", "tmp")
when "test"
  FILE_DIR = File.join(File.dirname(__FILE__), "..", "tmp")
end

class Wedding < Sinatra::Base
  configure do
    enable :logging
    Resque.redis = ENV["REDISTOGO_URL"] if ENV["REDISTOGO_URL"]
    #require_relative "../config/redis_config"
  end

  set :public_folder, File.join(File.dirname(__FILE__), "public")

  get "/" do
    status 200
    headers 'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    body File.open(File.join(settings.public_folder, 'index.html'), File::RDONLY)
  end

  post "/receive_email" do
    #begin
    #  puts "receiving photos!"
    #  puts params.inspect
    #  email = ParseEmail.new(params)
    #  email.create_files
    #  return 200
    #rescue
    #  puts $!.inspect
    #  puts $!.backtrace[0..5].join("\n")
    #  return 200
    #end
    200
  end

  get "/upload" do
    erb :upload
  end

  post "/upload" do

    time = Time.now

      # Profile the code

    params[:type] = params["file"][:type]
    params[:_file] = params[:file].dup
    params["file"] = params[:file][:tempfile]
    puts params.inspect
    a = Attachment.defer_processing(params)
    puts Time.now - time
    return 200
  end

end
