module AresMUSH
  module Profile
    class ProfileSaveRequestHandler
      def handle(request)
        
        enactor = request.enactor
        char = Character[request.args[:id]]

        error = Website.check_login(request)
        return error if error
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        manager = Profile.can_manage_profiles?(enactor)
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end

        if (!char.is_approved? && !manager)
          return { error: t('profile.not_yet_approved') }
        end
              
        request.args[:demographics].each do |name, value|
          if (value.blank? && Demographics.required_demographics.include?(name))
            return { error: t('webportal.missing_required_field', :name => name) }
          end
          if (name == 'birthdate')
            # Standard db format
            if (value =~ /\d\d\d\d-\d\d-\d\d/)
              char.update_demographic name, value
            # Game-specific format
            else
              result = Demographics.set_birthday(char, value)
              if (result[:error])
                return { error: result[:error] }
              end
            end
          else
            char.update_demographic name, value
          end
        end
        
        tags = (request.args[:tags] || []).map { |t| t.downcase }.select { |t| !t.blank? }
        gallery = (request.args[:profile_gallery] || '').split.map { |g| g.downcase }
        profile_image = build_image_path(char, request.args[:profile_image])
        profile_icon = build_image_path(char, request.args[:profile_icon])
        char.update(profile_image: profile_image)
        char.update(profile_icon: profile_icon)
        char.update(profile_gallery: gallery)
        char.update(profile_tags: tags)
        char.update(profile_order: (request.args[:profile_order] || "").split(',').map { |o| o.strip })
        
        relationships = {}
        (request.args[:relationships] || {}).each do |name, data|
          relationships[name] = {
            'relationship' => Website.format_input_for_mush(data['text']),
            'order' => data['order'].blank? ? nil : data['order'].to_i,
            'category' => data['category'].blank? ? "Associates" : data['category'].titleize,
            'is_npc' => (data['is_npc'] || "").to_bool,
            'npc_image' => data['npc_image'].blank? ? nil : data['npc_image']
            }
        end
        
        char.update(rp_hooks: Website.format_input_for_mush(request.args[:rp_hooks]))
        char.update(relationships: relationships)
        char.update(bg_shared: request.args[:bg_shared].to_bool)
        char.update(idle_lastwill: Website.format_input_for_mush(request.args[:lastwill]))
        
        relation_category_order = (request.args[:relationships_category_order] || "").split(',').map { |o| o.strip }
        char.update(relationships_category_order: relation_category_order)
        
        Describe.save_web_descs(char, request.args['descs'])

        errors = CustomCharFields.save_fields_from_profile_edit(char, request.args) || []
        if (errors.class == Array && errors.any?)
          return { error: errors.join("\n") }
        end
        
        if (Roles.can_assign_role?(enactor))
          error = Roles.save_web_roles(char, request.args['roles'], enactor)
          if (error)
            return { error: error }
          end
        end

        if (Idle.can_manage_roster?(enactor))
          Idle.save_web_roster_fields(char, request.args['roster'])
        end
        
        if (Chargen.can_manage_bgs?(enactor))
          char.update(cg_background: Website.format_input_for_mush(request.args[:background]))
        end
        
        if (Idle.can_idle_sweep?(enactor))
          char.update(idle_notes: Website.format_input_for_mush(request.args[:idle_notes]))
        end
        
        ## DO PROFILE LAST SO IT TRIGGERS THE SOURCE HISTORY UPDATE
        profile = {}
        (request.args[:profile] || {}).each do |name, text|
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


