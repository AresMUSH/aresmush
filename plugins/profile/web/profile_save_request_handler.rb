module AresMUSH
  module Profile
    class ProfileSaveRequestHandler
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
        pp request.args[:demographics]
        request.args[:demographics].each do |name, value|
          if (value.blank?)
            return { error: t('webportal.missing_required_fields') }
          end
          char.update_demographic name, value
        end
        
        char.update(profile_gallery: request.args[:gallery])
        char.update(profile_image: request.args[:profile_image])
        char.update(profile_icon: request.args[:profile_icon])
        char.update(profile_tags: request.args[:tags])
        
        relationships = {}
        (request.args[:relationships] || {}).each do |name, data|
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
        (request.args[:profile] || {}).each do |name, text|
          profile[name.titleize] = WebHelpers.format_input_for_mush(text)
        end
        char.set_profile(profile, enactor)
        
        
        {    
        }
      end
    end
  end
end


