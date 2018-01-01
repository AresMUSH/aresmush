module AresMUSH
  module WebHelpers
    def self.format_markdown_for_html(output)
      return nil if !output
        
      allow_html = Global.read_config('website', 'allow_html_in_markdown')
      text = AresMUSH::MushFormatter.format output, false
      #text = AnsiFormatter.strip_ansi(text)
      html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
      text = html_formatter.to_html text
      text
    end
      
    # Takes something from a text box and replaces carriage returns with %r's for MUSH.
    def self.format_input_for_mush(input)
      return nil if !input
      input.gsub(/\r\n/, '%r')
    end

    # Takes MUSH text and formats it for a text box with %r's becoming line breaks.      
    def self.format_input_for_html(input)
      return nil if !input
      input.gsub(/%r/i, '&#013;&#010;').gsub("\"", "&quot;")
    end
    
    def self.icon_for_char(char)
      if (char)
        icon = char.profile_icon
        if (icon.blank?)
          icon = char.profile_image
        end
      else
        icon = nil
      end
        
      icon.blank? ? nil : icon
    end
            
    def self.format_mush(text)
      text = MushFormatter.format(text, false)
      return AnsiFormatter.strip_ansi(text)
    end
    
    def self.validate_auth_token(request)
      return { error: "You are not logged in." } if !request.enactor
      token = request.auth[:token]
      if request.enactor.is_valid_api_token?(token)
        return nil
      end
      return { error: "Your session has expired.  Please log in again." } 
    end
  end
end