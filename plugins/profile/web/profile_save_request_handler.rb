module AresMUSH
  module Profile
    class ProfileSaveRequestHandler
      def handle(request)
        
        enactor = request.enactor
        char = Character[request.args['id']]
        tags = (request.args['tags'] || "").split(" ")

        error = Website.check_login(request)
        return error if error
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        Global.logger.info "#{enactor.name} saving profile for #{char.name}."
        
        manager = Profile.can_manage_profiles?(enactor)
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end

        if (!char.is_approved? && !manager)
          return { error: t('profile.not_yet_approved') }
        end
        
        gallery = (request.args['profile_gallery'] || '').split.map { |g| g.downcase }
        profile_image = build_image_path(char, request.args['profile_image'])
        profile_icon = build_image_path(char, request.args['profile_icon'])
        char.update(profile_image: profile_image)
        char.update(profile_icon: profile_icon)
        char.update(profile_gallery: gallery)
        char.update(profile_order: (request.args['profile_order'] || "").split(',').map { |o| o.strip })
        
        Website.update_tags(char, tags)
        
        relationships = {}
        (request.args['relationships'] || {}).each do |name, data|
          relationships[name] = {
            'relationship' => Website.format_input_for_mush(data['text']),
            'order' => data['order'].blank? ? nil : data['order'].to_i,
            'category' => data['category'].blank? ? "Associates" : data['category'].titleize,
            'is_npc' => (data['is_npc'] || "").to_bool,
            'npc_image' => data['npc_image'].blank? ? nil : data['npc_image']
            }
        end
        
        char.update(relationships: relationships)
        
        relation_category_order = (request.args['relationships_category_order'] || "").split(',').map { |o| o.strip }
        char.update(relationships_category_order: relation_category_order)
        
              
        error = Demographics.save_web_profile_data(char, enactor, request.args)
        if (error)
          return { error: error }
        end
        
        error = Chargen.save_web_profile_data(char, enactor, request.args)
        if (error)
          return { error: error }
        end
        
        error = Idle.save_web_profile_data(char, enactor, request.args)
        if (error)
          return { error: error }
        end
        
        Describe.save_web_descs(char, request.args['descs'])

        if Manage.is_extra_installed?("prefs")
          error = Prefs.save_web_profile_data(char, enactor, request.args)
          if (error)
            return { error: error }
          end
        end
        
        if FS3Skills.is_enabled?
          error = FS3Skills.save_web_profile_data(char, enactor, request.args)
          if (error)
            return { error: error }
          end
        end
        
        error = Roles.save_web_profile_data(char, enactor, request.args)
        if (error)
          return { error: error }
        end
        
        errors = CustomCharFields.save_fields_from_profile_edit2(char, enactor, request.args) || []
        if (errors.class == Array && errors.any?)
          return { error: errors.join("\n") }
        end
        
        ## DO PROFILE LAST SO IT TRIGGERS THE SOURCE HISTORY UPDATE
        profile = {}
        (request.args['profile'] || {}).each do |name, text|
          profile[name.titleize] = Website.format_input_for_mush(text)
        end
        char.set_profile(profile, enactor)
        
        Achievements.award_achievement(enactor, "profile_edit")
        
        
        {    
        }
      end
      
      def build_image_path(char, arg)
        return nil if !arg
        folder = Profile.character_page_folder(char)
        File.join folder, arg.downcase
      end
    end
  end
end


