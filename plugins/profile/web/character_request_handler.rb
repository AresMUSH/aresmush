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
        
        

        all_fields = Demographics.build_web_all_fields_data(char, enactor)
        demographics = Demographics.build_web_demographics_data(char, enactor)
        groups = Demographics.build_web_groups_data(char)

        profile = char.profile.each_with_index.map { |(section, data), index| 
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
          gallery_files = char.profile_gallery
        end
          
        
        relationships_by_category = Profile.relationships_by_category(char)
        relationships = relationships_by_category.map { |category, relationships| {
          name: category,
          key: category.parameterize(),
          relationships: relationships.sort_by { |name, data| [ data['order'] || 99, name ] }
             .map { |name, data| {
               name: name,
               is_npc: data['is_npc'],
               icon: data['npc_image'] || Website.icon_for_name(name),
               text: Website.format_markdown_for_html(data['relationship'])
             }
           }
        }}
        
        details = char.details.map { |name, desc| {
          name: name,
          desc: Website.format_markdown_for_html(desc)
        }}
        can_manage = enactor && Profile.can_manage_char_profile?(enactor, char)
        
        if (char.background.blank?)
          show_background = false
        else
          show_background = can_manage || char.on_roster? || char.bg_shared || Chargen.can_view_bgs?(enactor)
        end

        
        files = Profile.character_page_files(char)
        files = files.map { |f| Website.get_file_info(f) }
        
        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::CharProfileRequestHandler.new.handle(request)
        else
          fs3 = nil
        end
        
        if (enactor)
          Login.mark_notices_read(enactor, :achievement)
        end
          
        {
          id: char.id,
          name: char.name,
          name_and_nickname: Demographics.name_and_nickname(char),
          all_fields: all_fields,
          fullname: char.fullname,
          military_name: Ranks.military_name(char),
          icon: Website.icon_for_char(char),
          profile_image: Website.get_file_info(char.profile_image),
          demographics: demographics,
          groups: groups,
          handle: char.handle ? char.handle.name : nil,
          status_message: Profile.get_profile_status_message(char),
          tags: char.profile_tags,
          can_manage: can_manage,
          profile: profile,
          relationships: relationships,
          last_online: OOCTime.local_long_timestr(enactor, char.last_on),
          profile_gallery: gallery_files.map { |g| Website.get_file_info(g) },
          background: show_background ? Website.format_markdown_for_html(char.background) : nil,
          description: Website.format_markdown_for_html(char.description),
          details: details,
          rp_hooks: char.rp_hooks ? Website.format_markdown_for_html(char.rp_hooks) : '',
          desc: char.description,
          playerbit: char.is_playerbit?,
          fs3: fs3,
          files: files,
          last_profile_version: char.last_profile_version ? char.last_profile_version.id : nil,
          achievements: Achievements.is_enabled? ? Achievements.build_achievements(char) : nil,
          
          roster: self.build_roster_info(char),
          idle_notes: char.idle_notes ? Website.format_markdown_for_html(char.idle_notes) : nil,
          
        }
      end
      
      def build_roster_info(char)
        return nil if !char.on_roster?
        
        {
          notes: char.roster_notes ? Website.format_markdown_for_html(char.roster_notes) : nil,
          previously_played: char.roster_played,
          app_required: char.roster_restricted,
          contact: char.roster_contact
        }
      end
    end
  end
end