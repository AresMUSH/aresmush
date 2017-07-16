module AresMUSH
  class WebApp    
    
    helpers do
      
      def icon_for_name(name)
        char = Character.find_one_by_name(name)
        if (char)
          icon = char.icon
        else
          icon = nil
        end
        icon || "/noicon.png"
      end

      # Takes something from a text box and replaces carriage returns with %r's for MUSH.
      def format_input_for_mush(input)
        return nil if !input
        input.gsub(/\r\n/, '%r')
      end

      # Takes MUSH text and formats it for a text box with %r's becoming line breaks.      
      def format_input_for_html(input)
        return nil if !input
        input.gsub(/%r/i, '&#013;&#010;')
      end
      
      # Takes MUSH text and formats it for display in a div, with %r's becoming HTML breaks.
      def format_output_for_html(output)
        return nil if !output
        text = AresMUSH::ClientFormatter.format output, false
        text.strip.gsub(/[\r\n]/i, '<br/>')
      end
      
      def format_markdown_for_html(output)
        return nil if !output
        
        allow_html = Global.read_config('website', 'allow_html_in_markdown')
        renderer = Redcarpet::Render::HTML.new(escape_html: !allow_html, hard_wrap: true, 
              autolink: true, safe_links_only: true)    
        html = Redcarpet::Markdown.new(renderer, tables: true)
        text = AresMUSH::ClientFormatter.format output, false
        text = html.render text
        text = text.gsub(/\&quot\;/i, '"')
        text = text.gsub(/\[\[div([^\]]*)\]\]/i, '<div \1>')
        text = text.gsub(/\[\[span([^\]]*)\]\]/i, '<span \1>')
        
        #text = text.gsub(/\[\[div (class|style)=\&quot\;([^\]]*)\&quot\;\]\]/i, '<div \1="\2">')
        #text = text.gsub(/\[\[div\]\]/i, '<div>')
        text = text.gsub(/\[\[\/div\]\]/i, "</div>")
        text = text.gsub(/\[\[\/span\]\]/i, "</span>")
        text = text.gsub(/%r/i, "<br/>")
        text
      end
      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end

    end

  end
end
