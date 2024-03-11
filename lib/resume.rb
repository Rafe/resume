require 'yaml'
require 'tilt'
require 'github/markup'
require 'pdfkit'

class Resume
  def render_html
    Tilt.new("#{root_path}/index.haml").render({},
      title: "#{config['name']}'s resume",
      resume: resume_html,
      gkey: config['gkey'],
      url: config['url'],
      description: config['meta']['description'],
      keywords: config['meta']['keywords']
    )
  end

  def render_pdf
    pdf = PDFKit.new(digest_html, {
      page_size: 'A4',
      print_media_type: true,
    })
    pdf.stylesheets << 'docs/print.css'
    pdf
  end

  def render_text
    resume_file.delete('#')
      .gsub('-- ', '\n')
      .gsub(/_(.*)_/, '\1')
      .gsub(/\[(.*)\]\(.*\)/, '[\1]')
  end

  private

  def digest_html
    @digest_html ||= resume_html.split("<h2>Talks</h2>").first
  end

  def resume_html
    @resume_html ||= GitHub::Markup.render(config["file"], resume_file)
  end

  def resume_file
    @resume_file ||= File.read(File.join(root_path, config['file']))
  end

  def config
    @config ||= YAML.load_file(File.join(root_path, 'config.yml'))
  end

  def root_path
    File.expand_path(File.join(File.dirname(__FILE__), '../'))
  end
end
