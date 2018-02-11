module AresMUSH
  module Profile
    class ProfileEditRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character[request.args[:id]]
        
        if (!enactor)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
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
        
        Global.read_config('demographics')['editable_properties'].sort.each do |d| 
          demographics[d.downcase] = 
            {
              name: t("profile.#{d.downcase}_title"),
              value: char.demographic(d)
            }
        end
                  
        profile = char.profile.sort.each_with_index.map { |(section, data), index| 
          {
            name: section.titlecase,
            text: WebHelpers.format_input_for_html(data),
            key: index
          }
        }
        
        relationships = char.relationships.sort.each_with_index.map { |(name, data), index| {
          name: name,
          category: data['category'],
          key: index,
          order: data['order'],
          text: WebHelpers.format_input_for_html(data['relationship'])
        }}
        
        files = Dir[File.join(AresMUSH.website_uploads_path, "#{char.name.downcase}/**")]
        files = files.sort.map { |f| WebHelpers.get_file_info(f) }
        
        {
          id: char.id,
          name: char.name,
          fullname: char.demographic(:fullname),
          demographics: demographics,
          background: WebHelpers.format_input_for_html(char.background),
          rp_hooks: WebHelpers.format_input_for_html(char.rp_hooks),
          desc: WebHelpers.format_input_for_html(char.description),
          shortdesc: char.shortdesc ? char.shortdesc.description : '',
          relationships: relationships,
          profile: profile,
          gallery: (char.profile_gallery || {}).map { |f| WebHelpers.get_file_info(f) },
          tags: char.profile_tags,
          files: files, 
          profile_image: char.profile_image ? WebHelpers.get_file_info(char.profile_image) : nil,
          profile_icon: char.profile_icon ? WebHelpers.get_file_info(char.profile_icon) : nil,
          bg_shared: char.bg_shared
          
        }
      end
    end
  end
end


