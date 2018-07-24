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
        
        if (FS3Combat.is_enabled?)
          damage = char.damage.map { |d| {
            date: d.ictime_str,
            description: d.description,
            severity: Website.format_markdown_for_html(FS3Combat.display_severity(d.initial_severity))
          }          
        }
      else
        damage = nil
      end
        
      show_sheet = FS3Skills.can_view_sheets?(enactor) || (enactor && enactor.id == char.id)
        
      if (show_sheet)
        {
          attributes: get_ability_list(char.fs3_attributes),
          action_skills: get_ability_list(char.fs3_action_skills),
          backgrounds: get_ability_list(char.fs3_background_skills),
          languages: get_ability_list(char.fs3_languages),
          advantages: get_ability_list(char.fs3_advantages),
          use_advantages: FS3Skills.use_advantages?,
          damage: damage,
          show_sheet: show_sheet
        }
      else
        {
          damage: damage,
          show_sheet: show_sheet
        }
      end
    end
      
    def get_ability_list(list)        
      list.to_a.sort_by { |a| a.name }.map { |a| 
        { 
          name: a.name, 
          rating: a.rating, 
          rating_name: a.rating_name
          }}
        end
            
      end
    end
  end

