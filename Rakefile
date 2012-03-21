require 'rake'
require 'erb'

task :environment do
  require './lib/wedding'
end

task :default =>[:build]

desc "Compile the assets!"
task :compile do
  puts %x[compass compile --sass-dir lib/asssets/stylesheets/ --css-dir lib/public/stylesheets --images-dir lib/public/images/ ]
end

desc "make index" 
task :build do
  Rake::Task['compile'].execute
  stories = []
  layout = File.read("lib/views/layout.html.erb")
  pages = ["welcome", "about-us", "our-story", "ceremony-reception", "travel-info", "registry"]
  pages.each do |page|
    article = File.read("lib/views/content/#{page}.html")
    
    id = page
    template = ERB.new(article)
    result = template.result(binding)
    stories << result
  end
  index =  ERB.new(layout).result(binding)
  File.open("index.html", "w") {|f| f.write index }
end

require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
