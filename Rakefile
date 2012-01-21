require 'rake'
require 'erb'

task :default =>[:build]

desc "Compile the assets!"
task :compile do
  %x[compass compile]
end

desc "make index" 
task :build do
  Rake::Task['compile'].execute
  stories = []
  layout = File.read("layout.html.erb")
  pages = ["welcome", "about-us", "our-story", "ceremony-reception", "travel-info", "registry"]
  pages.each do |page|
    article = File.read("content/#{page}.html")
    
    id = page
    template = ERB.new(article)
    result = template.result(binding)
    stories << result
  end
  index =  ERB.new(layout).result(binding)
  File.open("index.html", "w") {|f| f.write index }
end
