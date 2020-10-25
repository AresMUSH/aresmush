module AresMUSH
  module Profile
    class ProfileEditRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name(request.args[:id])
        
        error = Website.check_login(request)
        return error if error
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        profile_manager = Profile.can_manage_profiles?(enactor)
        bg_manager = Chargen.can_manage_bgs?(enactor)
        roster_manager = Idle.can_manage_roster?(enactor)
        idle_manager = Idle.can_idle_sweep?(enactor)
        role_manager = Roles.can_assign_role?(enactor)
        show_admin_tab = idle_manager || roster_manager || role_manager || bg_manager
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!char.is_approved? && !profile_manager)
          return { error: t('profile.not_yet_approved') }
        end
        
        demographics = {}
        profile = {}
        relationships = {}
        
        if (profile_manager)
          props = Demographics.all_demographics
        else
          props = Global.read_config('demographics')['editable_properties']
        end
                
        props.each do |d| 
          demographics[d.downcase] = 
            {
              name: d.titlecase,
              value: char.demographic(d)
            }
        end
                  
        profile = char.profile.sort.each_with_index.map { |(section, data), index| 
          {
            name: section.titlecase,
            text: Website.format_input_for_html(data),
            key: index
          }
        }
        
        relationships = char.relationships.sort_by { |name, data| [ data['category'], data['order'] || 99, name ] }
          .each_with_index.map { |(name, data), index| {
          name: name,
          category: data['category'],
          key: index,
          order: data['order'],
          is_npc: data['is_npc'],
          npc_image: data['npc_image'],
          text: Website.format_input_for_html(data['relationship'])
        }}
        
        roster = {
            on_roster: char.on_roster?,
            notes: Website.format_input_for_html(char.roster_notes),
            contact: char.roster_contact,
            played: char.roster_played,
            restricted: char.roster_restricted
          }
        
        files = Profile.character_page_files(char)
        files = files.sort.map { |f| Website.get_file_info(f) }
        
        
        {
          id: char.id,
          name: char.name,
          demographics: demographics,
          background: Website.format_input_for_html(char.background),
          show_background_tab: bg_manager,
          show_roster_tab: roster_manager,
          show_roles_tab: role_manager,
          show_idle_tab: idle_manager,
          show_admin_tab: show_admin_tab,
          rp_hooks: Website.format_input_for_html(char.rp_hooks),
          desc: Website.format_input_for_html(char.description),
          shortdesc: char.shortdesc ? char.shortdesc : '',
          relationships: relationships,
          relationships_category_order: char.relationships_category_order.join(","),
          profile: profile,
          profile_gallery: (char.profile_gallery || []).join(' '),
          tags: char.profile_tags,
          files: files, 
          profile_image: char.profile_image ? Website.get_file_info(char.profile_image) : nil,
          profile_icon: char.profile_icon ? Website.get_file_info(char.profile_icon) : nil,
          profile_order: char.profile_order.join(","),
          bg_shared: char.bg_shared,
          lastwill: Website.format_input_for_html(char.idle_lastwill),
          idle_notes: Website.format_input_for_html(char.idle_notes),
          custom: CustomCharFields.get_fields_for_editing(char, enactor),
          descs: Describe.get_web_descs_for_edit(char),
          genders: Demographics.genders,
          roster: roster,
          roles: char.roles.map { |r| r.name },
          all_roles: Role.all.to_a.sort_by { |r| r.name }.map { |r| r.name }
        }
      end
    end
  end
end


