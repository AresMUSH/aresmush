module AresMUSH
  module FS3Skills
    class CharProfileRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        enactor = request.enactor
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error
      
        is_owner = (enactor && enactor.id == char.id)
        
        if (FS3Combat.is_enabled?)
          damage = char.damage.to_a.sort { |d| d.created_at }.map { |d| {
            date: d.ictime_str,
            description: d.description,
            original_severity: MushFormatter.format(FS3Combat.display_severity(d.initial_severity)),
            severity: MushFormatter.format(FS3Combat.display_severity(d.current_severity))
            }}
        else
          damage = nil
        end
        
        show_sheet = FS3Skills.can_view_sheets?(enactor) || is_owner
        
        if (FS3Skills.can_view_xp?(enactor, char))
          xp = {
            attributes: get_xp_list(char, char.fs3_attributes),
            action_skills: get_xp_list(char, char.fs3_action_skills),
            backgrounds: get_xp_list(char, char.fs3_background_skills),
            languages: get_xp_list(char, char.fs3_languages),
            advantages: get_xp_list(char, char.fs3_advantages),
            xp_points: char.fs3_xp,
            can_learn: is_owner,
            allow_advantages_xp: Global.read_config("fs3skills", "allow_advantages_xp")
          }
        else
          xp = nil
        end
      
        if (show_sheet)
          {
            attributes: get_ability_list(char.fs3_attributes),
            action_skills: get_ability_list(char.fs3_action_skills, true),
            backgrounds: get_ability_list(char.fs3_background_skills),
            languages: get_ability_list(char.fs3_languages),
            advantages: get_ability_list(char.fs3_advantages),
            use_advantages: FS3Skills.use_advantages?,
            damage: damage,
            show_sheet: show_sheet,
            luck_points: char.luck.floor,
            xp: xp
          }
        else
          {
            damage: damage,
            show_sheet: show_sheet,
            xp: xp
          }
        end
      end
    
      def get_ability_list(list, include_specs = false)        
        list.to_a.sort_by { |a| a.name }.map { |a| 
          { 
            name: a.name, 
            rating: a.rating, 
            rating_name: a.rating_name,
            specialties: include_specs ? a.specialties.join(", ") : nil,
            linked_attr: include_specs ? FS3Skills.get_linked_attr(a.name)[0..2].upcase : nil
          }}
      end
      
      def get_xp_list(char, list)
        list.to_a.sort_by { |a| a.name }.map { |a| {
          name: a.name,
          rating: a.rating,
          can_raise: !FS3Skills.check_can_learn(char, a.name, a.rating),
          progress: a.xp_needed ? a.xp * 100.0 / a.xp_needed : 0,
          xp: a.xp,
          xp_needed: a.xp_needed,
          days_to_learn: FS3Skills.days_to_next_learn(a)
        }}
      end
    end
  end
end

