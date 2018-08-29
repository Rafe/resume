$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), './lib'))

require 'resume'

task :default => :generate

def load_config
  autoload :YAML, 'yaml'
  YAML.load_file "config.yml"
end

desc "start the server"
task :up => :generate do
  exec "rackup"
end

desc "generate resume.pdf and index.html"
task :generate do

  resume = Resume.new

  page = resume.render_html
  File.open("docs/index.html", "w") { |f| f.write(page) }

  pdf = resume.render_pdf
  pdf.to_file('docs/resume.pdf')

  text = resume.render_text
  File.open("docs/resume.txt", "w" ) { |file| file.write(text) }

  puts "generate resume files complete"
end
