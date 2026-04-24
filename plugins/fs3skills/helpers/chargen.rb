module AresMUSH
  module FS3Skills

    def self.set_ability(char, ability_name, rating)
      ability_name = ability_name ? ability_name.titleize : nil
      error = FS3Skills.check_ability_name(ability_name)
      if (error)
        return error
      end
      
      ability_type = FS3Skills.get_ability_type(ability_name)
      
      min_rating = FS3Skills.get_min_rating(ability_type)
      ability = FS3Skills.find_ability(char, ability_name)
      
      if (ability)
        ability.update(rating: rating)
      else
        case ability_type
        when :action
          ability = FS3ActionSkill.create(character: char, name: ability_name, rating: rating)
        when :background
          ability = FS3BackgroundSkill.create(character: char, name: ability_name, rating: rating)
        when :language
          ability = FS3Language.create(character: char, name: ability_name, rating: rating)
        when :advantage
          ability = FS3Advantage.create(character: char, name: ability_name, rating: rating)
        when :attribute
          ability = FS3Attribute.create(character: char, name: ability_name, rating: rating)
        end
      end
      
      rating_name = ability.rating_name
      
      if (rating == min_rating)
        if (ability && (ability_type == :background || ability_type == :language || ability_type == :advantage))
          ability.delete
        end
      end
      
      return nil
    end
    
    # Checks to make sure an ability name doesn't have any funky characters in it.
    def self.check_ability_name(ability)
      return t('fs3skills.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end
    
    def self.ability_raised_text(char, ability_name)
      ability = FS3Skills.find_ability(char, ability_name)
      if (ability)
        ability_type = FS3Skills.get_ability_type(ability_name)
        t("fs3skills.#{ability_type}_set", :name => ability.name, :rating => ability.rating_name)
      else
        t("fs3skills.ability_removed", :name => ability_name)
      end
    end
    
    def self.get_min_rating(ability_type)
      case ability_type
      when :action
        if (Global.read_config('fs3skills', 'allow_incapable_action_skills'))
          min_rating = 0
        else
          min_rating = 1
        end
      when :background, :language, :advantage
        min_rating = 0
      when :attribute
        min_rating = 1
      end
      min_rating
    end
    
    def self.get_max_rating(ability_type)
      case ability_type
      when :action
        max_rating = Global.read_config("fs3skills", "max_skill_rating")
      when :background, :language, :advantage
        max_rating = 3
      when :attribute
        max_rating = Global.read_config("fs3skills", "max_attr_rating")
      end
    end
    
    def self.check_rating(ability_name, rating)
      ability_type = FS3Skills.get_ability_type(ability_name)
      min_rating = FS3Skills.get_min_rating(ability_type)
      max_rating = FS3Skills.get_max_rating(ability_type)

      return t('fs3skills.max_rating_is', :rating => max_rating) if (rating > max_rating)
      return t('fs3skills.min_rating_is', :rating => min_rating) if (rating < min_rating)
      return nil
    end
    
    def self.reset_char(char)
      char.fs3_action_skills.each { |s| s.delete }
      char.fs3_attributes.each { |s| s.delete }
      char.fs3_background_skills.each { |s| s.delete }
      char.fs3_languages.each { |s| s.delete }
      char.fs3_advantages.each { |s| s.delete }
        
      FS3Skills.attr_names.each do |a|
        FS3Skills.set_ability(char, a, 2)
      end
        
      FS3Skills.action_skill_names.each do |a|
        FS3Skills.set_ability(char, a, 1)
      end
        
      starting_skills = StartingSkills.get_groups_for_char(char)
        
      starting_skills.each do |k, v|
        set_starting_skills(char, k, v)
      end
      
      starting_specialties = StartingSkills.get_specialties_for_char(char)
      starting_specialties.each do |skill_name, specs|
        specs.each do |spec|
          FS3Skills.add_specialty(char, skill_name, spec)
        end
      end
    end
      
    def self.set_starting_skills(char, group, skill_config)
      return if !skill_config
        
      skills = skill_config["skills"]
      return if !skills
        
      skills.each do |k, v|
        FS3Skills.set_ability(char, k, v)
      end
    end
    
    def self.add_specialty(char, skill_name, spec_name)
      ability = FS3Skills.find_ability(char, skill_name)
      if (!ability)
        return t('fs3skills.ability_not_found')
      end
    
      specialties = FS3Skills.action_specialties(skill_name)
    
      if (!specialties.include?(spec_name))   
        return t('fs3skills.invalid_specialty', :names => specialties.join(", "))
      end
    
      if (ability.specialties.include?(spec_name))
        return t('fs3skills.specialty_already_exists', :name => char.name)
      end
    
      new_specs = ability.specialties
      new_specs << spec_name
      ability.update(specialties: new_specs)
      return nil
    end
  end
end