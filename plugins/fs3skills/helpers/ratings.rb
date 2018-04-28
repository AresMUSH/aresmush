module AresMUSH
  module FS3Skills

    def self.find_ability(char, ability_name)
      ability_name = ability_name.titlecase
      ability_type = FS3Skills.get_ability_type(ability_name)
      case ability_type
      when :attribute
        char.fs3_attributes.find(name: ability_name).first
      when :action
        char.fs3_action_skills.find(name: ability_name).first
      when :background
        char.fs3_background_skills.find(name: ability_name).first
      when :advantage
        char.fs3_advantages.find(name: ability_name).first
      when :language
        char.fs3_languages.find(name: ability_name).first
      else
        nil
      end
    end
    
    def self.get_linked_attr(ability_name)
      case FS3Skills.get_ability_type(ability_name)
      when :action
        config = FS3Skills.action_skill_config(ability_name)
        return config["linked_attr"]
      when :attribute
        return nil
      else
        return Global.read_config("fs3skills", "default_linked_attr")
      end
    end
  end
end