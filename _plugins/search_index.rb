require 'json'
require 'nokogiri'
require 'kramdown'
require 'fileutils'


module Jekyll
  class SearchIndexGenerator < Generator
    priority :lowest

    def generate(site)
      index = []

      documents = site.pages + site.posts.docs

      documents.each do |doc|
        next unless doc.output_ext == '.html'
        next if doc.url == '/search.json'

        html = rendered_html(doc)
        next if html.strip.empty?

        parsed = Nokogiri::HTML(html)
        title = doc.data['title'] || 'Untitled'

        parsed.css('h1, h2, h3, h4, h5, h6').each do |heading|

          id = heading['id']
          next unless id

          section_text = heading.text.strip
          next if section_text.empty?

          # Collect content under this heading until the next heading
          content_parts = []
          sibling = heading.next_sibling
          while sibling
            break if sibling.element? && sibling.name.match?(/^h[1-6]$/)
            content_parts << sibling.text.strip if sibling.text?
            content_parts << sibling.text.strip if sibling.element?
            sibling = sibling.next_sibling
          end

          content = ([section_text] + content_parts).join(' ').gsub(/\s+/, ' ').strip

          index << {
            title: title,
            section: section_text,
            url: "#{doc.url}##{id}",
            content: content
          }
        end
      end
      file_name = 'search.json'
      file_path = File.join(site.source, file_name)
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, 'w') do |f|
        f.write(JSON.pretty_generate(index))
      end
      site.static_files << Jekyll::StaticFile.new(site, site.source, '/', file_name)
    end

    # Render markdown or HTML as needed
    def rendered_html(doc)
      if doc.extname == '.md' && doc.content
        Kramdown::Document.new(doc.content).to_html
      elsif doc.extname == '.html' && doc.content
        doc.content
      else
        ''
      end
    end
  end
end
