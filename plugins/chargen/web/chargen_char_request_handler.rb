module AresMUSH
  module Chargen
    class ChargenCharRequestHandler
      def handle(request)
        char = request.enactor
        
        if (!char)
          return { error: t('webportal.login_required') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error

        if (char.is_approved?)
          return { error: t('chargen.you_are_already_approved')}
        end
                
        return { chargen_locked: true } if Chargen.is_chargen_locked?(char)
        
        demographics = {}
        
        Demographics.basic_demographics.sort.each do |d| 
          demographics[d.downcase] = 
            {
              name: d.titleize,
              value: char.demographic(d)
            }
        end
        
        demographics['age'] = { name: t('profile.age_title'), value: char.age }
        demographics['actor'] = { name: t('profile.actor_title'), value: char.demographic(:actor)}
        
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
        
          
        hooks = WebHelpers.format_input_for_html(char.rp_hooks)
        
        {
          id: char.id,
          chargen_locked: char.chargen_locked,
          name: char.name,
          fullname: char.demographic(:fullname),
          demographics: demographics,
          groups: groups,
          background: WebHelpers.format_input_for_html(char.background),
          rp_hooks: hooks,
          desc: WebHelpers.format_input_for_html(char.description),
          shortdesc: char.shortdesc ? char.shortdesc.description : '',
          fs3: fs3
        }
      end
    end
  end
end


