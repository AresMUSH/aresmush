module AresMUSH
  module FS3Skills
    def self.receives_roll_results?(actor)
      actor.has_permission?("receives_roll_results")
    end
    
    def self.can_manage_abilities?(actor)
      actor.has_permission?("manage_abilities")
    end
    
    def self.can_view_sheets?(actor)
      actor.has_permission?("view_sheets")
    end

    def self.attrs
      Global.read_config("fs3skills", "attributes")
    end
    
    def self.action_skills
      Global.read_config("fs3skills", "action_skills")
    end 
    
    def self.languages
      Global.read_config("fs3skills", "languages")
    end
    
    def self.attr_names
      attrs.map { |a| a['name'].titlecase }
    end
    
    def self.action_skill_names
      action_skills.map { |a| a['name'].titlecase }
    end
    
    def self.language_names
      languages.map { |l| l['name'].titlecase }
    end

    def self.action_skill_config(name)
      FS3Skills.action_skills.find { |s| s["name"].upcase == name.upcase }
    end
    
    # Returns the type (attribute, action, etc) for a skill being rolled.
    def self.get_ability_type(ability)
      ability = ability.titlecase
      if (attr_names.include?(ability))
        return :attribute
      elsif (action_skill_names.include?(ability))
        return :action
      elsif (language_names.include?(ability))
        return :language
      else
        return :background
      end        
    end
    
    def self.skills_census
      skills = {}
      Idle::Api.active_chars.each do |c|
        c.fs3_action_skills.each do |a|
          add_to_hash(skills, c, a)
        end

        c.fs3_background_skills.each do |a|
          add_to_hash(skills, c, a)
        end
        
        c.fs3_languages.each do |a|
          add_to_hash(skills, c, a)
        end
      end
      skills = skills.select { |name, people| people.count > 2 }
      skills = skills.sort_by { |name, people| [0-people.count, name] }
      skills
    end
    
    
    private
    
    def self.add_to_hash(hash, char, skill)
      if (hash[skill.name])
        hash[skill.name] << "#{char.name}:#{skill.rating}"
      else
        hash[skill.name] = ["#{char.name}:#{skill.rating}"]
      end
    end  
  end
end