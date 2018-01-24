module AresMUSH
  module Profile
    class ProfileSaveRequestHandler
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
        
        request.args[:demographics].each do |name, value|
          if (value.blank?)
            return { error: "#{name} cannot be blank." }
          end
          char.update_demographic name, value
        end
        
        char.update(profile_gallery: request.args[:gallery])
        char.update(profile_image: request.args[:profile_image])
        char.update(profile_icon: request.args[:profile_icon])
        char.update(profile_tags: request.args[:tags])
        
        relationships = {}
        request.args[:relationships].each do |name, data|
          relationships[name.titleize] = {
            relationship: WebHelpers.format_input_for_mush(data['text']),
            order: data['order'].blank? ? nil : data['order'].to_i,
            category: data['category'].blank? ? "Associates" : data['category'].titleize
            }
        end
        
        char.update(rp_hooks: WebHelpers.format_input_for_mush(request.args[:rp_hooks]))
        char.update(relationships: relationships)
        char.update(bg_shared: request.args[:bg_shared].to_bool)
        
        
        ## DO PROFILE LAST SO IT TRIGGERS THE SOURCE HISTORY UPDATE
        profile = {}
        request.args[:profile].each do |name, text|
          profile[name.titleize] = WebHelpers.format_input_for_mush(text)
        end
        char.set_profile(profile, enactor)
        
        
        {    
        }
      end
    end
  end
end


