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
    
    def self.is_restricted_wiki_page?(page)
      restricted_pages = Global.read_config("website", "restricted_pages") || ['home']
      restricted_pages.map { |p| WikiPage.sanitize_page_name(p.downcase) }.include?(page.name.downcase)
    end
    
    def self.can_manage_wiki?(actor)
      actor && actor.has_permission?("manage_wiki")
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
    
    def self.get_file_info(file_path)
      return nil if !file_path
      relative_path = file_path.gsub(AresMUSH.website_uploads_path, '')
      {
      path: relative_path,
      name: File.basename(relative_path),
      folder: File.dirname(relative_path).gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
      }
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
          created_at: p.created_at,
          created: OOCTime.local_long_timestr(nil, p.created_at),
          name: p.character.name,
          author: p.author_name
        }
      end
      recent_wiki.each do |w|
        recent_changes << {
          title: w.wiki_page.heading,
          id: w.id,
          change_type: 'wiki',
          created_at: w.created_at,
          created: OOCTime.local_long_timestr(nil, w.created_at),
          name: w.wiki_page.name,
          author: w.author_name
        }
      end
        
      recent_changes = recent_changes.sort_by { |r| r[:created_at] }.reverse
      
      if (limit)
        recent_changes[0..limit]
      else
        recent_changes
      end
      
    end 
    
    def self.rebuild_css
      engine_styles_path = File.join(AresMUSH.engine_path, 'styles')
      scss_path = File.join(engine_styles_path, 'ares.scss')
      css_path = File.join(AresMUSH.website_styles_path, 'ares.css')
      load_paths = [ engine_styles_path, AresMUSH.website_styles_path ]
      css = Sass::Engine.for_file(scss_path, { load_paths: load_paths }).render
      File.open(css_path, "wb") {|f| f.write(css) }
    end
    
    def self.deploy_portal(client = nil)
      Global.dispatcher.spawn("Deploying website", nil) do
        WebHelpers.rebuild_css
        install_path = Global.read_config('website', 'website_code_path')
        Dir.chdir(install_path) do
          output = `bin/deploy 2>&1`
          Global.logger.info "Deployed web portal: #{output}"
          client.emit_ooc t('webportal.portal_deployed', :output => output) if client
        end
      end
    end
    
    def self.welcome_text
      welcome_filename = File.join(AresMUSH.game_path, "text", "website.txt")
      text = File.read(welcome_filename, :encoding => "UTF-8")
      WebHelpers.format_markdown_for_html(text)
    end
  end
end