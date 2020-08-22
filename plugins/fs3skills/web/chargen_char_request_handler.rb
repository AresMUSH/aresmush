module AresMUSH
  module FS3Skills
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
        
        if (!Chargen.can_approve?(enactor))
          if (char != enactor)
            return { error: t('dispatcher.not_allowed') }
          end

          if (char.is_approved?)
            return { error: t('chargen.you_are_already_approved')}
          end
                
          return { chargen_locked: true } if Chargen.is_chargen_locked?(char)
        end        
        
        {
          fs3_attributes: get_ability_list(char, char.fs3_attributes, :attribute),
          fs3_action_skills: get_ability_list(char, char.fs3_action_skills, :action),
          fs3_backgrounds: get_ability_list(char, char.fs3_background_skills, :background),
          fs3_languages: get_ability_list(char, char.fs3_languages, :language),
          fs3_advantages: get_ability_list(char, char.fs3_advantages, :advantage),
          reset_needed: !char.fs3_attributes.map { |a| a.rating > 1 }.any?,
          use_advantages: FS3Skills.use_advantages?
        } 
      end
      
      
      def get_ability_list(char, list, ability_type)
        case ability_type
        when :attribute
          metadata = FS3Skills.attrs
          starting_rating = 1
          starting_rating_name = t('fs3skills.poor_rating')
        when :action
          metadata = FS3Skills.action_skills
          starting_rating = 1
          starting_rating_name = t('fs3skills.everyman_rating')
        when :language
          metadata = FS3Skills.languages
          starting_rating = 0
          starting_rating_name = t('fs3skills.everyman_rating')
        when :advantage
          metadata = FS3Skills.advantages
          starting_rating = 0
          starting_rating_name = t('fs3skills.everyman_rating')
        else
          metadata = nil
        end
        
        abilities = list.to_a.sort_by { |a| a.name }.map { |a| 
          { 
            name: a.name, 
            rating: a.rating, 
            rating_name: a.rating_name,
            desc: (metadata) ? FS3Skills.get_ability_desc(metadata, a.name) : nil,
            specialties: (metadata) ? build_specialty_list(char, metadata, a.name) : nil
          }}
          
          if (metadata)
            metadata.each do |m|
              existing = abilities.select { |a| a[:name].titlecase == m['name'].titlecase }.first
              if (!existing)
                abilities << { name: m['name'].titlecase, desc: m['desc'], rating_name: starting_rating_name, rating: starting_rating}
              end
            end
          end
                    
          abilities.sort_by { |a| a[:name] }
      end
      
      def build_specialty_list(char, metadata, ability_name)
        metadata = metadata.select { |m| m['name'] == ability_name }.first
        return nil if !metadata
        specialty_names = metadata['specialties']

        return nil if !specialty_names
        
        specialties = []
        specialty_names.each do |s|
          ability = FS3Skills.find_ability(char, ability_name)
          if (ability)
            specialties << { name: s, selected: ability.specialties.include?(s) }
          end
        end
        
        specialties
      end
      
    end
  end
end


