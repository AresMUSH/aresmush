module AresMUSH
  module Chargen
    class ChargenCharRequestHandler
      def handle(request)
        id = request.args[:id]
        enactor = request.enactor
        char = Character.find_one_by_name id
        if (!char)
          return { error: t('webportal.login_required') }
        end

        error = Website.check_login(request)
        return error if error
                

        
        if (Chargen.can_approve?(enactor))
          can_approve = true
        else
          can_approve = false
          if (char != enactor)
            return { error: t('dispatcher.not_allowed') }
          end

          if (char.is_approved?)
            return { error: t('chargen.you_are_already_approved')}
          end
                
          return { chargen_locked: true } if Chargen.is_chargen_locked?(char)
        end
        
        all_demographics = Demographics.all_demographics
        demographics = {}
        
        all_demographics.select { |d| d != 'birthdate' }.each do |d| 
          demographics[d.downcase] = 
            {
              name: d.titleize,
              value: char.demographic(d)
            }
        end
        
        if (Demographics.age_enabled?)
          demographics['age'] = { name: t('profile.age_title'), value: char.birthdate ? OOCTime.format_date_for_entry(char.birthdate) : char.age }
        end
        
        groups = {}
        
        Demographics.all_groups.sort.each do |k, v| 
          group_val = char.group(k)
          groups[k.downcase] = {
            name: k.titleize,
            value: group_val,
            desc: (v['values'] || {})[group_val]
          }
        end
        
        if (Ranks.is_enabled?)
          groups['rank'] = { name: t("profile.rank_title"), key: 'Rank', value: char.rank }
        end
        
        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::ChargenCharRequestHandler.new.handle(request)
        else
          fs3 = nil
        end
        
        if Manage.is_extra_installed?("traits")
          traits = Traits.get_traits_for_web_editing(char, char)
        else
          traits = nil
        end
          
        hooks = Website.format_input_for_html(char.rp_hooks)
        
        {
          id: char.id,
          chargen_locked: false,
          can_approve: can_approve,
          name: char.name,
          demographics: demographics,
          groups: groups,
          background: Website.format_input_for_html(char.background),
          rp_hooks: hooks,
          profile_image: char.profile_image,
          desc: Website.format_input_for_html(char.description),
          shortdesc: Website.format_input_for_html(char.shortdesc),
          lastwill: Website.format_input_for_html(char.idle_lastwill),
          fs3: fs3,
          traits: traits,
          custom: Profile::CustomCharFields.get_fields_for_chargen(char)
        }
      end
    end
  end
end


