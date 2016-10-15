module AresMUSH
  module FS3Skills

    # Expects titleized ability name and numeric rating
    def self.set_ability(client, char, ability_name, rating)
      error = FS3Skills.check_ability_name(ability_name)
      if (error)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
      ability_type = get_ability_type(ability_name)
      
      error = FS3Skills.check_rating(ability_name, rating)
      if (error)
        if (client)
          client.emit_failure error
        end
        return false
      end
      
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
        when :attribute
          ability = FS3Attribute.create(character: char, name: ability_name, rating: rating)
        end
      end
      
      rating_name = ability.rating_name
      
      if (rating == min_rating)
        if (ability && (ability_type == :background || ability_type == :language))
          ability.delete
        end
      end
      
      if (client)
        if (client.char_id == char.id)
          client.emit_success t("fs3skills.#{ability_type}_set", :name => ability_name, :rating => rating_name)
        else
          client.emit_success t("fs3skills.admin_ability_set", :name => char.name, :ability_type => ability_type, :ability_name => ability_name, :rating => rating_name)
        end
      end
      return true
    end
    
    # Checks to make sure an ability name doesn't have any funky characters in it.
    def self.check_ability_name(ability)
      return t('fs3skills.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end
    
    def self.get_min_rating(ability_type)
      case ability_type
      when :action
        min_rating = 0
      when :background
        min_rating = 0
      when :language
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
      when :background
        max_rating = 3
      when :language
        max_rating = 3
      when :attribute
        max_rating = 5
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
  end
end