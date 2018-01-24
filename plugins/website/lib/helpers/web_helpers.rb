module AresMUSH
  module WebHelpers
    def self.format_markdown_for_html(output)
      return nil if !output
        
      text = format_output_for_html(output)
      allow_html = Global.read_config('website', 'allow_html_in_markdown')
      html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, self)
      text = html_formatter.to_html text
      text
    end
    
    def self.format_output_for_html(output)
      return nil if !output
        
      AresMUSH::MushFormatter.format output, false
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
      WebHelpers.icon_for_char(char)
    end
    
    def self.check_login(request, allow_anonymous = false)
      return nil if allow_anonymous
      return { error: "You need to log in first." } if !request.enactor
      token = request.auth[:token]
      if request.enactor.is_valid_api_token?(token)
        return nil
      end
      return { error: "Your session has expired.  Please log in again." } 
    end
    
    
    def self.get_recent_changes(unique_only = false, limit = nil)
      sixty_days_in_seconds = 86400 * 60
      
      recent_profiles = ProfileVersion.all.select { |p| Time.now - p.created_at < sixty_days_in_seconds }
      recent_wiki = WikiPageVersion.all.select { |w| Time.now - w.created_at < sixty_days_in_seconds}
      
      if (unique_only)
         recent_profiles =  recent_profiles.sort_by { |p| p.created_at }
            .reverse
            .uniq { |p| p.character }
          recent_wiki = recent_wiki.sort_by { |w| w.created_at }
            .reverse
            .uniq { |w| w.wiki_page }
      end
          
      recent_changes = []
      recent_profiles.each do |p|
        recent_changes << {
          title: p.character.name,
          id: p.id,
          change_type: 'char',
          created: p.created_at,
          name: p.character.name,
          author: p.author_name
        }
      end
      recent_wiki.each do |w|
        recent_changes << {
          title: w.wiki_page.heading,
          id: w.id,
          change_type: 'wiki',
          created: w.created_at,
          name: w.wiki_page.name,
          author: w.author_name
        }
      end
        
      recent_changes = recent_changes.sort_by { |r| r[:created] }.reverse
      
      if (limit)
        recent_changes[0..limit]
      else
        recent_changes
      end
      
    end 
  end
end