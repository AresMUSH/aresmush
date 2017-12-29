module AresMUSH
  module WebHelpers
    def self.format_markdown_for_html(output)
      return nil if !output
        
      allow_html = Global.read_config('website', 'allow_html_in_markdown')
      text = AresMUSH::MushFormatter.format output, false
      text = AnsiFormatter.strip_ansi(text)
      html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
      text = html_formatter.to_html text
      text
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
  end
end