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
        
        profile = Profile.build_profile_sections_web_data(char)
        
        gallery_files = Profile.character_gallery_files(char)
        
        relationships = Profile.build_profile_relationship_web_data(char)
        
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
          
        prefs = Manage.is_extra_installed?("prefs") ? Website.format_markdown_for_html(char.rp_prefs) : nil
          
        profile_data = {
          id: char.id,
          name: char.name,
          profile_title: Profile.profile_title(char),
          name_and_nickname: Demographics.name_and_nickname(char),
          fullname: char.fullname,
          icon: Website.icon_for_char(char),
          profile_image: Website.get_file_info(char.profile_image),
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.content_tags,
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
          rp_prefs: prefs,
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
          profile_data['fs3'] = FS3Skills.build_web_char_data(char, enactor)
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
        
        if Manage.is_extra_installed?("cookies")
          profile_data['cookies'] = Cookies.get_web_sheet(char, enactor)
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