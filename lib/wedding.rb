require 'bundler/setup'
require 'active_support/all'
require 'redis'
require 'sinatra'
require 'uuidtools'
require 'tempfile'
require 'aws/s3'
require 'exifr'
require 'RMagick'

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
    a = Attachment.new(params)
    puts a.inspect
    a.create_s3_file!
    a.create_s3_thumb!
    a.create_photo!

    puts Time.now - time
    "SUCCESS"
  end

end
