module AresMUSH
  class WebApp    
    
    helpers do
      
      def icon_for_name(name)
        char = Character.find_one_by_name(name)
        icon_for_char(char)
      end
      
      def icon_for_char(char)
        if (char)
          icon = char.profile_icon
          if (icon.blank?)
            icon = char.profile_image
          end
        else
          icon = nil
        end
        
        icon.blank? ? "/images/noicon.png" : "/files/#{icon}"
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
        text.strip.gsub(/[\n]/i, '<br/>')
      end
      
      def format_markdown_for_html(output)
        return nil if !output
        
        allow_html = Global.read_config('website', 'allow_html_in_markdown')
        text = AresMUSH::ClientFormatter.format output, false
        html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
        text = html_formatter.to_html text
        text
      end

      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end

    end

  end
end
