root = File.expand_path(File.dirname(__FILE__))

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
  require 'tilt'
  require 'github/markup'
  require 'pdfkit'

  config = load_config
  file = config['file']
  title = config['name'] + "'s resume"
  gkey = config['gkey']
  url = config['url']

  resume = GitHub::Markup.render(file,File.read(file))
  template = Tilt.new("#{root}/index.haml")
  page = template.render({}, { title: title, 
                               resume: resume,
                               gkey: gkey ,
                               url: url 
                        })

  File.open("public/index.html", "w") { |f| f.write(page) }

  PDFKit.new(resume, :page_size => 'A4') do |pdf|
    pdf.stylesheets << "public/style.css" 
    pdf.to_file('public/resume.pdf')
  end

  system "cp #{root}/resume.md #{root}/public/resume.txt"

  puts "generate resume files complete"
end

#Github Task originally from https://github.com/icco/Resume
desc "publish the static files to gh-page"
task :github => :generate do
  require 'git'
  require 'logger'

  remote = load_config["github"]

  tmp = "/tmp/checkout-#{Time.now.to_i}"
  git = Git.clone(remote, tmp, :log => Logger.new(STDOUT)) 

  git.branch("gh-pages").checkout

  begin
    #hack for ruby-git's pull command can't correctlly fetch remote branch
    #https://github.com/schacon/ruby-git/issues/32
    git.lib.send(:command, 'pull origin gh-pages')
  rescue
    puts "pull fail"
  end

  git.remove("*",:recursive => true)
  system "cp -Rf #{root}/public/ #{tmp}/"
  git.add(".")

  git.commit('Regenerating Github Pages.')

  git.push(git.remote('origin'), git.branch('gh-pages'))

  puts 'GitHub Pages Commit and Push successful.'
end
