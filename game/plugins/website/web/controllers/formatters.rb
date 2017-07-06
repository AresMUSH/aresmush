module AresMUSH
  class WebApp    
    
    helpers do

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
        renderer = Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true, 
              autolink: true, safe_links_only: true)    
        html = Redcarpet::Markdown.new(renderer)
        text = html.render output
        format_output_for_html(text)
      end
      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end

    end

  end
end
