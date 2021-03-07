module AresMUSH
  module Profile
    class CharacterRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error
        
        profile = char.profile
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
        
        if (char.profile_gallery.empty?)
          gallery_files = Profile.character_page_files(char) || []
        else
          gallery_files = char.profile_gallery.select { |g| g =~ /\w\.\w/ }
        end
        
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
        
        can_manage = enactor && Profile.can_manage_char_profile?(enactor, char)
        
        files = Profile.character_page_files(char)
        files = files.map { |f| Website.get_file_info(f) }
        
        if (enactor)
          if (enactor.is_admin?)
            siteinfo = Login.build_web_site_info(char, enactor)
          end
          Login.mark_notices_read(enactor, :achievement)
        else
          siteinfo = nil
        end
          
        profile_data = {
          id: char.id,
          name: char.name,
          name_and_nickname: Demographics.name_and_nickname(char),
          fullname: char.fullname,
          icon: Website.icon_for_char(char),
          profile_image: Website.get_file_info(char.profile_image),
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.profile_tags,
          can_manage: can_manage,
          profile: profile,
          relationships: relationships,
          last_online: OOCTime.local_long_timestr(enactor, char.last_on),
          profile_gallery: gallery_files.map { |g| Website.get_file_info(g) },
          playerbit: char.is_playerbit?,
          files: files,
          last_profile_version: char.last_profile_version ? char.last_profile_version.id : nil,
          show_notes: char == enactor || Utils.can_manage_notes?(enactor),
          siteinfo: siteinfo,
          custom: CustomCharFields.get_fields_for_viewing(char, enactor),
        }
        
        add_to_profile profile_data, Demographics.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Describe.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Ranks.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Achievements.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Idle.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Chargen.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Roles.build_web_profile_data(char, enactor)
        add_to_profile profile_data, Scenes.build_web_profile_data(char, enactor)
        
        if (FS3Skills.is_enabled?)
          profile_data['fs3'] = FS3Skills::CharProfileRequestHandler.new.handle(request)
        end
        
        if Manage.is_extra_installed?("traits")
          profile_data['traits'] = Traits.get_traits_for_web_viewing(char, enactor)
        end
        
        if Manage.is_extra_installed?("rpg")
          profile_data['rpg'] = Rpg.get_sheet_for_web_viewing(char, enactor)
        end
        
        if Manage.is_extra_installed?("fate")
          profile_data['fate'] = Fate.get_web_sheet(char, enactor)
        end
        
        profile_data
      end
      
      def add_to_profile(profile_data, sections)
        sections.each do |name, data|
          profile_data[name] = data
        end
      end
    end
  end
end