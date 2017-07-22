module AresMUSH
  
  module Website
    
    # Enables the //italics// format that everyone is used to.
    class HTMLWithWikiExtensions < Redcarpet::Render::HTML
      def initialize(tag_blocks, options)
        @tag_blocks = tag_blocks
        super options
      end
      
      def postprocess(text)
        text = text.gsub(/\/\/([^\/\r\n]+)\/\//, '*\1*')
        text = text.gsub(/\&quot\;/i, '"')
        text = text.gsub(/\[\[div([^\]]*)\]\]/i, '<div \1>')
        text = text.gsub(/\[\[span([^\]]*)\]\]/i, '<span \1>')
        text = text.gsub(/\[\[\/div\]\]/i, "</div>")
        text = text.gsub(/\[\[\/span\]\]/i, "</span>")        

        @tag_blocks.each do |tag, block|
          text = text.gsub(/\[\[#{tag} ([^\]]*)\]\]/i) { block.call(Regexp.last_match[1]) }
        end
        
        text
      end
    end

    class WikiMarkdownFormatter
      def initialize(escape_html, tag_blocks)
        
        options = {
                tables: true,
                no_intra_emphasis: true,
                autolink: true,
                fenced_code_blocks: true
            }
            
        renderer = HTMLWithWikiExtensions.new(tag_blocks, 
            hard_wrap: true, 
            autolink: true, 
            safe_links_only: true,
            escape_html: escape_html)
            
        @engine = Redcarpet::Markdown.new(renderer, options)
      end
  
      def to_html(markdown)
        @engine.render markdown
      end
  
    end

  end
end

