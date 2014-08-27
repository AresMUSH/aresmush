module AresMUSH
  module FS3Skills
    def self.attributes
      Global.config['fs3skills']['attributes']
    end
    
    def self.action_skills
      Global.config['fs3skills']['action_skills']
    end 

    def self.background_skills
      Global.config['fs3skills']['background_skills']
    end 

    def self.languages
      Global.config['fs3skills']['languages']
    end
    
    def self.attribute_names
      attributes.map { |a| a['name'].titleize }
    end
    
    def self.action_skill_names
      action_skills.map { |a| a['name'].titleize }
    end

    # Expects titleized ability name
    def self.get_ability_type(ability)
      if (attribute_names.include?(ability))
        return :attribute
      elsif (action_skill_names.include?(ability))
        return :action
      else
        return :background
      end        
    end
    
    def self.get_ability_hash(char, ability_type)
      if (ability_type == :attribute)
        char.fs3_attributes
      elsif (ability_type == :action)
        char.action_skills
      else
        char.background_skills
      end
    end
    
    def self.get_max_rating(ability_type)
      ability_type == :attribute ? 4 : 12
    end
    
    # Expects titleized ability name and numeric rating
    def self.set_ability(client, char, ability, rating)
      ability_type = get_ability_type(ability)
      ability_hash = get_ability_hash(char, ability_type)
      max_rating = get_max_rating(ability_type)
      
      if (rating > max_rating)
        client.emit_failure t('fs3skills.max_rating_is', :rating => max_rating)
        return
      end
      
      update_hash(ability_hash, ability, rating)
      char.save
      client.emit_success t("fs3skills.#{ability_type}_set", :name => ability, :rating => rating)
    end
    
    def self.update_hash(hash, name, rating)
      if (rating == 0)
        hash.delete name
      else
        hash[name] = rating
      end
    end
  end
end