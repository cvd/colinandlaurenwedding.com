require 'sinatra'

class Wed < Sinatra::Base
  configure do
    enable :logging
  end

  get "/" do
    puts settings.public_folder
    status 200
    headers 'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    body File.open('index.html', File::RDONLY)
  end

  get "receive_email" do
    puts "INCOMING EMAIL!!!"
    puts params.inspect
  end

end
