module AresMUSH
  module FS3Skills
    def self.receives_roll_results?(char)
      char.has_any_role?(Global.read_config("fs3skills", "roles", "receives_roll_results"))
    end
    
    def self.can_manage_abilities?(actor)
      actor.has_any_role?(Global.read_config("fs3skills", "roles", "can_manage_abilities"))
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
      attrs.map { |a| a['name'].titleize }
    end
    
    def self.action_skill_names
      action_skills.map { |a| a['name'].titleize }
    end
    
    def self.language_names
      languages.map { |l| l['name'].titleize }
    end

    def self.action_skill_config(name)
      FS3Skills.action_skills.find { |s| s["name"].upcase == name.upcase }
    end
    
    # Returns the type (attribute, action, etc) for a skill being rolled.
    def self.get_ability_type(ability)
      ability = ability.titleize
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
  end
end