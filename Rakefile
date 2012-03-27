root = File.expand_path(File.dirname(__FILE__))

task :default => [:generate]

desc "start the server"
task :up do
  exec "rackup"
end

desc "generate resume.pdf and index.html"
task :generate do
  require 'tilt'
  require 'github/markup'
  require 'pdfkit'

  file = "resume.md"
  title = "Jimmy Chao"
  resume = GitHub::Markup.render(file,File.read(file))
  template = Tilt.new("#{root}/index.haml")
  page = template.render({}, { title: title, resume: resume })

  File.open("public/index.html", "w") { |f| f.write(page) }
  pdf = PDFKit.new(resume, :page_size => 'A4', 
                   :zoom => '1', 
                   :print_media_type => true)
  pdf.stylesheets << "public/style.css" 
  pdf.to_file('public/resume.pdf')
  exec "cp #{root}/resume.md #{root}/public/resume.txt"
end

#Github Task originally from https://github.com/icco/Resume
desc "publish the static files to gh-page"
task :github => [:generate] do
  require 'git'

  remote = "git://"
  tmp = "tmp/checkout-#{Time.now.to_i}"
  git = Git.clone(remote, tmp, :log => Logger.new(STDOUT))

  git.checkout(g.branch('gh-pages'))

  exec "cp -R #{root}/public/ #{tmp}/"
  git.add(".")

  git.commit('Regenerating Github Pages.')

  git.push(g.remote('origin'), g.branch('gh-pages'))

  puts '--> GitHub Pages Commit and Push successful.'
end
