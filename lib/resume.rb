require 'yaml'
require 'tilt'
require 'github/markup'
require 'pdfkit'

class Resume
  def render_html
    Tilt.new("#{root}/index.haml").render({},
      title: title,
      resume: markdown,
      gkey: gkey,
      url: url,
      description: description,
      keywords: keywords
    )
  end

  def render_pdf
    pdf = PDFKit.new(markdown, {
      page_size: 'A4',
      print_media_type: true,
    })
    pdf.stylesheets << 'docs/print.css'
    pdf
  end

  def render_text
    File.open("#{root}/resume.md", 'r') do |file|
      # Strip out markdown format
      file.read.delete('#')
          .gsub('-- ', '\n')
          .gsub(/_(.*)_/, '\1')
          .gsub(/\[(.*)\]\(.*\)/, '[\1]')
    end
  end

  def markdown
    @markdown ||= GitHub::Markup.render(file, File.read(file_path))
  end

  private

  def root
    File.expand_path(File.join(File.dirname(__FILE__), '../'))
  end

  def config
    @config ||= YAML.load_file File.join(root, 'config.yml')
  end

  def file_path
    File.join(root, file)
  end

  def file
    config['file']
  end

  def title
    "#{config['name']}'s resume'"
  end

  def gkey
    config['gkey']
  end

  def url
    config['url']
  end

  def description
    config['meta']['description']
  end

  def keywords
    config['meta']['keywords']
  end

  def resume
    Github::Markup.render(file, File.read(file))
  end

  def template
    Tilt.new(File.join(root, 'index.haml'))
  end
end
