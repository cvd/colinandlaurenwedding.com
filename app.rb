require 'sinatra'

class Wed < Sinatra::Base
  configure do
    enable :logging
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
  end

  get "/receive_email" do
    puts "incoming email!!!"
    puts params.inspect
  end

end
