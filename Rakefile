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
  description = config['meta']['description']
  keywords = config['meta']['keywords']

  resume = GitHub::Markup.render(file,File.read(file))
  template = Tilt.new("#{root}/index.haml")
  page = template.render({}, { title: title, 
                               resume: resume,
                               gkey: gkey ,
                               url: url ,
                               description: description, 
                               keywords: keywords
                        })

  File.open("public/index.html", "w") { |f| f.write(page) }

  PDFKit.configure do |config|
    config.default_options = {
      :page_size     => 'A4',
      :print_media_type => true,
      :margin_top => '0.2',
      :margin_bottom => '0.2',
    }
  end

  pdf = PDFKit.new(resume)
  pdf.stylesheets << "public/print.css" 
  pdf.to_file('public/resume.pdf')

  # Strip out markdown format
  File.open("#{root}/resume.md","r") do |f|
    resume = f.read
    resume.gsub!("#","")
    resume.gsub!("-- ","\n")
    resume.gsub!(/_(.*)_/,'\1')
    File.open("#{root}/public/resume.txt","w") { |text| text.write(resume) }
  end

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
    puts "--> GitHub pull fails or don't required pull "
  end

  git.remove("*",:recursive => true)
  system "cp -Rf #{root}/public/ #{tmp}/"
  git.add(".")

  git.commit('Regenerating Github Pages.')

  git.push(git.remote('origin'), git.branch('gh-pages'))

  puts 'GitHub Pages Commit and Push successful.'
end
