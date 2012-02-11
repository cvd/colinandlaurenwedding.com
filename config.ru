require './app/app.rb'

run Wed.new



#require 'rack'
#use Rack::Static,
#  :urls => ["/stylesheets", "/images", "/javascripts"],
#  :root => "public"
#
#run lambda { |env|
#  # build
#  [
#    200,
#    {
#      'Content-Type'  => 'text/html',
#      'Cache-Control' => 'public, max-age=86400'
#    },
#    File.open('index.html', File::RDONLY)
#  ]
#}
#
#def build
#  stories = []
#  layout = File.read("layout.html.erb")
#  pages = ["welcome", "about-us", "our-story", "ceremony-reception", "travel-info", "registry"]
#  pages.each do |page|
#    article = File.read("content/#{page}.html")
#    
#    id = page
#    template = ERB.new(article)
#    result = template.result(binding)
#    stories << result
#  end
#  index =  ERB.new(layout).result(binding)
#  File.open("public/index.html", "w") {|f| f.write index }
#end
