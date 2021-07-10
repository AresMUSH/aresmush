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

        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!char.is_approved? && !profile_manager)
          return { error: t('profile.not_yet_approved') }
        end
        
        profile = {}
        relationships = {}
        
                  
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
        
        
        files = Profile.character_page_files(char)
        files = files.sort.map { |f| Website.get_file_info(f) }
        
        
        profile_data = {
          id: char.id,
          name: char.name,
          relationships: relationships,
          relationships_category_order: char.relationships_category_order.join(","),
          profile: profile,
          profile_gallery: (char.profile_gallery || []).join(' '),
          tags: char.content_tags,
          files: files, 
          profile_image: char.profile_image ? Website.get_file_info(char.profile_image) : nil,
          profile_icon: char.profile_icon ? Website.get_file_info(char.profile_icon) : nil,
          profile_order: char.profile_order.join(","),
          custom: CustomCharFields.get_fields_for_editing(char, enactor)
        }
        
        add_to_profile profile_data, Demographics.build_web_profile_edit_data(char, enactor, profile_manager)
        add_to_profile profile_data, Chargen.build_web_profile_edit_data(char, enactor, profile_manager)
        add_to_profile profile_data, Idle.build_web_profile_edit_data(char, enactor, profile_manager)
        add_to_profile profile_data, Describe.build_web_profile_edit_data(char, enactor, profile_manager)
        add_to_profile profile_data, Roles.build_web_profile_edit_data(char, enactor, profile_manager)
        
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


