$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), './lib'))

require 'resume'

task :default => :generate

desc "start the server"
task :up => :generate do
  exec "rackup"
end

desc "generate resume.pdf and index.html"
task :generate do

  resume = Resume.new

  page = resume.render_html
  File.open("public/index.html", "w") { |f| f.write(page) }

  pdf = resume.render_pdf
  pdf.to_file('public/resume.pdf')

  text = resume.render_text
  File.open("public/resume.txt", "w" ) { |file| file.write(text) }

  puts "generate resume files complete"
end

#Github Task originally from https://github.com/icco/Resume
desc "publish the static files to gh-page"
task :github => :generate do
  require 'git'
  require 'logger'

  remote = load_config["github"]

  root = File.dirname(__FILE__)
  tmp = "/tmp/checkout-#{Time.now.to_i}"
  git = Git.clone(remote, tmp, :log => Logger.new(STDOUT)) 

  git.branch("gh-pages").checkout

  begin
    #hack for ruby-git's pull command can't correctlly fetch remote branch
    #https://github.com/schacon/ruby-git/issues/32
    git.lib.send(:command, 'pull origin gh-pages')
  rescue
    puts "--> GitHub pull fails or don't required pull "
  end

  git.remove("*",:recursive => true)
  system "cp -Rf #{root}/public/ #{tmp}/"
  git.add(".")

  git.commit('Regenerating Github Pages.')

  git.push(git.remote('origin'), git.branch('gh-pages'))

  puts 'GitHub Pages Commit and Push successful.'
end
