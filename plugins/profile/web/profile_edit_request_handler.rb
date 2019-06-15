module AresMUSH
  module Profile
    class ProfileEditRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character[request.args[:id]]
        
        error = Website.check_login(request)
        return error if error
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!char.is_approved?)
          return { error: t('profile.not_yet_approved') }
        end
        
        demographics = {}
        profile = {}
        relationships = {}
        
        Global.read_config('demographics')['editable_properties'].each do |d| 
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
        
        relationships = char.relationships.sort.each_with_index.map { |(name, data), index| {
          name: name,
          category: data['category'],
          key: index,
          order: data['order'],
          text: Website.format_input_for_html(data['relationship'])
        }}
        
        files = Profile.character_page_files(char)
        files = files.sort.map { |f| Website.get_file_info(f) }
        
        {
          id: char.id,
          name: char.name,
          demographics: demographics,
          background: Website.format_input_for_html(char.background),
          rp_hooks: Website.format_input_for_html(char.rp_hooks),
          desc: Website.format_input_for_html(char.description),
          shortdesc: char.shortdesc ? char.shortdesc : '',
          relationships: relationships,
          profile: profile,
          gallery: (char.profile_gallery || {}).map { |f| Website.get_file_info(f) },
          tags: char.profile_tags,
          files: files, 
          profile_image: char.profile_image ? Website.get_file_info(char.profile_image) : nil,
          profile_icon: char.profile_icon ? Website.get_file_info(char.profile_icon) : nil,
          bg_shared: char.bg_shared,
          lastwill: Website.format_input_for_html(char.idle_lastwill),
          
        }
      end
    end
  end
end


