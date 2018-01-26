module AresMUSH
  module Chargen
    class ChargenCharRequestHandler
      def handle(request)
        char = request.enactor
        
        if (!char)
          return { error: "You must log in first." }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (char.is_approved?)
          return { error: "You have already completed character creation." }
        end
        
        demographics = {}
        
        Demographics.basic_demographics.sort.each do |d| 
          demographics[d.downcase] = 
            {
              name: d.titleize,
              value: char.demographic(d)
            }
        end
        
        demographics['age'] = { name: "Age", value: char.age }
        demographics['actor'] = { name: "Played By", value: char.demographic(:actor)}
        
        groups = {}
        
        Demographics.all_groups.sort.each do |k, v| 
          group_val = char.group(k)
          groups[k.downcase] = {
            name: k.titleize,
            value: group_val,
            desc: v['values'][group_val]
          }
        end
        
        if (Ranks.is_enabled?)
          groups['rank'] = { name: "Rank", value: char.rank }
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
          fs3_attributes: get_ability_list(char, char.fs3_attributes, :attribute),
          fs3_action_skills: get_ability_list(char, char.fs3_action_skills, :action),
          fs3_backgrounds: get_ability_list(char, char.fs3_background_skills, :background),
          fs3_languages: get_ability_list(char, char.fs3_languages, :language),
          reset_needed: !char.fs3_attributes.any?
        }
      end
      
      def get_ability_list(char, list, ability_type)
        case ability_type
        when :attribute
          metadata = FS3Skills.attrs
          starting_rating = 1
          starting_rating_name = "Poor"
        when :action
          metadata = FS3Skills.action_skills
          starting_rating = 1
          starting_rating_name = "Everyman"
        when :language
          metadata = FS3Skills.languages
          starting_rating = 0
          starting_rating_name = "Unskilled"
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
              existing = abilities.select { |a| a[:name] == m['name'] }.first
              if (!existing)
                abilities << { name: m['name'], desc: m['desc'], rating_name: starting_rating_name, rating: starting_rating}
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


