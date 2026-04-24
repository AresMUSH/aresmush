module AresMUSH
  module Profile
    def self.relationships_by_category(char)
      groups = {}
      char.relationships.each do |name, rel|
        categories = (rel['category'] || "None").split(",")
        categories.each do |cat|
          if (!groups.has_key?(cat))
            groups[cat] = {}
          end
          groups[cat][name] = rel
        end
      end
      groups.sort_by { |category, relations| Profile.category_order(char, category) }

      
      #relations = char.relationships.group_by { |name, data| data['category'] }
      #relations.sort_by { |category, relations| Profile.category_order(char, category) }
    end
    
    def self.category_order(char, category)
      char.relationships_category_order.map { |r| r.upcase }.index(category.upcase) || (category[0] || "1").ord
    end
    
    def self.can_manage_profiles?(actor)
      actor && actor.has_permission?("manage_profiles")
    end
    
    def self.can_manage_char_profile?(actor, char)
      return false if !actor
      return true if Profile.can_manage_profiles?(actor)
      return true if actor == char
      
      return AresCentral.is_alt?(actor, char)
    end
    
    def self.character_page_folder(char)
      Website::FilenameSanitizer.sanitize(char.name.downcase)
    end
    
    # ALL files associated with a character
    def self.character_page_files(char)
      name = Profile.character_page_folder(char)
      Dir[File.join(AresMUSH.website_uploads_path, "#{name}/**")].sort
    end
    
    # Allows player to customize which files are shown in their gallery or change the order.
    def self.character_gallery_files(char)
      if (char.profile_gallery.empty?)
        gallery_files = (Profile.character_page_files(char) || []).map { |f| f.gsub(AresMUSH.website_uploads_path, '') }
      else
        gallery_files = char.profile_gallery.select { |g| g =~ /\w\.\w/ }
      end
      gallery_files
    end
    
    # Moves character files, but you still have to manually update any links to them.
    def self.move_character_files(model, new_name)
      old_folder = File.join(AresMUSH.website_uploads_path, Profile.character_page_folder(model))
      new_folder = File.join(AresMUSH.website_uploads_path, Website::FilenameSanitizer.sanitize(new_name.downcase))
      FileUtils.mv(old_folder, new_folder)
    end
    
    def self.export_wiki_char(model)
      if (model.wiki_char_backup)
        return t('profile.wiki_backup_avail', :path => model.wiki_char_backup.download_path)
      end
      
      if (Time.now - (model.profile_last_backup || 0) < 86400)
        return t('profile.wiki_backup_too_soon')
      end
          
      model.update(profile_last_backup: Time.now)
      
      Global.dispatcher.queue_timer(1, "Wiki backup #{model.name}", nil) do
        error = Website.export_char(model)
        if (error)
          model.update(profile_last_backup: nil)
          Login.notify model, :backup, t('profile.wiki_backup_failed', :error => error), ''
        else
          message = t('profile.wiki_backup_created', :path => model.wiki_char_backup.download_path, :hours => WikiCharBackup.retention_hours)
          Login.notify model, :backup, message, ''
          Login.emit_if_logged_in(model, message)
        end
      end
      
      return nil
    end
    
    def self.reset_wiki_backup(char)
      if (char.wiki_char_backup)
        char.wiki_char_backup.delete
      end
      char.update(profile_last_backup: nil)
    end
    
    def self.get_profile_status_message(char)
      case char.idle_state
      when "Roster"
        return t('profile.char_on_roster')
      when "Gone"
        return t('profile.char_gone')
      when "Dead"
        return t('profile.char_dead')
      else
        if (char.is_npc?)
          return t('profile.char_is_npc')
        elsif (char.is_admin?)
          return t('profile.char_is_admin')
        elsif (char.is_playerbit?)
          return t('profile.char_is_playerbit')
        elsif (!char.is_approved?)
          return t('profile.char_not_approved')
        else
          return nil
        end
      end
    end
    
    def self.build_profile_sections_web_data(char)
      char.profile
        .sort_by { |k, v| [ char.profile_order.index { |p| p.downcase == k.downcase } || 999, k ] }
        .each_with_index
        .map { |(section, data), index| 
          {
            name: section.titlecase,
            key: section.parameterize(),
            text: Website.format_markdown_for_html(data),
            active_class: index == 0 ? 'active' : ''  # Stupid bootstrap hack
          }
        }
    end
    
    def self.build_profile_relationship_web_data(char)
      relationships_by_category = Profile.relationships_by_category(char)
      relationships = relationships_by_category.map { |category, relationships| {
        name: category,
        key: category.parameterize(),
        relationships: relationships.sort_by { |name, data| [ data['order'] || 99, name ] }
           .map { |name, data| {
             name: name,
             is_npc: data['is_npc'],
             icon: data['is_npc'] ? data['npc_image'] : Website.icon_for_name(name),
             name_and_nickname: Demographics.name_and_nickname(Character.named(name)),
             text: Website.format_markdown_for_html(data['relationship'])
           }
         }
      }}
    end
  end
end