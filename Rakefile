require_relative "./lib/resume"

task :default => :generate

desc "start the server"
task :up => :generate do
  exec "rackup"
end

desc "generate resume.pdf and index.html"
task :generate do
  resume = Resume.new

  File.open("docs/index.html", "w") do |file|
    file.write(resume.render_html)
  end

  resume.render_pdf.to_file('docs/resume.pdf')

  File.open("docs/resume.txt", "w" ) do |file|
    file.write(resume.render_text)
  end

  puts "generate resume files complete"
end
