module AresMUSH
  
  module Website
    
    # Enables the //italics// format that everyone is used to.
    class HTMLWithWikiExtensions < Redcarpet::Render::HTML
      def initialize(pre_tag_blocks, post_tag_blocks, options)
        @pre_tag_blocks = pre_tag_blocks
        @post_tag_blocks = post_tag_blocks
        super options
      end
      
      def preprocess(text)
      
        text = text.gsub(/\[\[tabnavlist\]\]/i, '<ul class="nav nav-tabs">')
        text = text.gsub(/\[\[\/tabnavlist\]\]/i, '</ul>')
        
        text = text.gsub(/\[\[tabnav ([^\]]*)\]\]/i) do |input|
          name = Regexp.last_match[1]
          id = (name || "").gsub(' ', '-').downcase
          "<li><a data-toggle=\"tab\" href=\"##{id}\">#{name}</a></li>" 
        end
                
        @pre_tag_blocks.each do |tag, block|
          text = text.gsub(/\[\[#{tag} ([^\]]*)\]\]/i) { block.call(Regexp.last_match[1]) }
        end
        text
      end
      
      def wiki_url(text)
        if (text =~ /\|/)
          url = text.before('|')
          link = text.after('|')
        else
          url = text
          link = text
        end
        
        "<a href=\"/wiki/#{url}\">#{link}</a>"
      end
      
      def postprocess(text)
        text = text.gsub(/\/\/([^\/\r\n]+)\/\//, '<em>\1</em>')
        text = text.gsub(/\&quot\;/i, '"')
        text = text.gsub(/\[\[div([^\]]*)\]\]/i, '<div \1>')
        text = text.gsub(/\[\[span([^\]]*)\]\]/i, '<span \1>')
        text = text.gsub(/\[\[\/div\]\]/i, "</div>")
        text = text.gsub(/\[\[\/span\]\]/i, "</span>")        
        text = text.gsub(/\[\[tabview\]\]/i, '<div class="tab-content">')
        text = text.gsub(/\[\[\/tabview\]\]/i, '</div>')
        text = text.gsub(/\[\[\/tab\]\]/i, '</div>')
        
        text = text.gsub(/\[\[\[([^\]]*)\]\]\]/i) { wiki_url(Regexp.last_match[1]) }
                        
        text = text.gsub(/\[\[tab ([^\]]*)\]\]/i) do |input|
          id = (Regexp.last_match[1] || "").gsub(' ', '-').downcase
          "<div id=\"#{id}\" class=\"tab-pane fade in\">"
        end
        
        
        @post_tag_blocks.each do |tag, block|
          text = text.gsub(/\[\[#{tag} ([^\]]*)\]\]/i) { block.call(Regexp.last_match[1]) }
        end
        
        text
      end
    end

    class WikiMarkdownFormatter
      def initialize(escape_html, pre_tag_blocks, post_tag_blocks)
        
        options = {
                tables: true,
                no_intra_emphasis: true,
                autolink: true,
                fenced_code_blocks: true
            }
            
        renderer = HTMLWithWikiExtensions.new(pre_tag_blocks, post_tag_blocks, 
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

