module AresMUSH
  module Profile
    class ProfileEditRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character[request.args[:id]]
        
        if (!enactor)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!char)
          return { error: "Character not found." }
        end
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: "You are not allowed to do that." }
        end
        
        if (!char.is_approved?)
          return { error: "You have to finish character creation first." }
        end
        
        demographics = {}
        profile = {}
        relationships = {}
        
        Global.read_config('demographics')['editable_properties'].sort.each do |d| 
          demographics[d.downcase] = 
            {
              name: d.titleize,
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
        files = files.sort.map { |f| { name: File.basename(f), path: f.gsub(AresMUSH.website_uploads_path, '') }}
        
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
          gallery: char.profile_gallery.map { |f| { name: File.basename(f), path: f }},
          tags: char.profile_tags,
          files: files, 
          profile_image: { name: char.profile_image.after('/') },
          profile_icon: { name: char.profile_icon.after('/') },
          bg_shared: char.bg_shared
          
        }
      end
    end
  end
end


