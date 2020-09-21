module AresMUSH
  module Website
    def self.format_markdown_for_html(output)
      return nil if !output
        
      text = format_output_for_html(output)
      text = text.gsub(ANSI.reset, " #{ANSI.reset}")
      allow_html = Global.read_config('website', 'allow_html_in_markdown')
      html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
      text = html_formatter.to_html text
      text
    end
      
    # Weird edge case that you might want to ignore markdown formatting but still do MUSH format codes.
    def self.format_output_for_html(output)
      return nil if !output
        
      AresMUSH::MushFormatter.format output
    end
      
    # Takes something from a text box and replaces carriage returns with %r's for MUSH.
    def self.format_input_for_mush(input)
      return nil if !input
      input.gsub(/\r\n/, '%r').gsub(/\n/, '%r')
    end

    # Takes MUSH text and formats it for a text box with %r's becoming line breaks.      
    def self.format_input_for_html(input)
      return nil if !input
      input.gsub(/%r/i, "\n")
    end
    
    def self.avatar_info(char)
      {
        name: char.name,
        nick: char.nick,
        icon: Website.icon_for_char(char)
      }
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
    
    def self.icon_for_name(name)
      char = Character.find_one_by_name(name)
      Website.icon_for_char(char)
    end
    
    def self.web_char_marker
      "[#{t('global.web_status')}]"
    end
    
    def self.activity_status(char)
      Status.activity_status(char)
    end
    
    def self.can_manage_theme?(actor)
      actor && actor.has_permission?("manage_theme")
    end
  end
end