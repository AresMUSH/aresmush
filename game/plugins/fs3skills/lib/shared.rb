module AresMUSH
  module FS3Skills
    def self.receives_roll_results?(char)
      char.has_any_role?(Global.config['fs3skills']['roles']['receives_roll_results'])
    end
    
    def self.can_manage_abilities?(actor)
      actor.has_any_role?(Global.config['fs3skills']['roles']['can_manage_abilities'])
    end

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
    # Returns the type (attribute, action, background) for a skill being rolled.
    def self.get_ability_type(ability)
      if (attribute_names.include?(ability))
        return :attribute
      elsif (action_skill_names.include?(ability))
        return :action
      else
        return :background
      end        
    end
    
    # Gets the appropriate data hash from the character object based on
    # the ability type.  This can be used to look up rating, ruling attribute, etc.
    def self.get_ability_hash(char, ability_type)
      if (ability_type == :attribute)
        char.fs3_attributes
      elsif (ability_type == :action)
        char.fs3_action_skills
      else
        char.fs3_background_skills
      end
    end
    
    def self.get_max_rating(ability_type)
      ability_type == :attribute ? 4 : 12
    end
    
    def self.get_min_rating(ability_type)
      ability_type == :attribute ? 1 : 0
    end
    
    # Expects titleized ability name.  Returns a hash containing the ability properties
    # like rating and (if applicable) ruling attr.
    def self.get_ability(char, ability)
      ability_type = get_ability_type(ability)
      ability_hash = get_ability_hash(char, ability_type)
      ability_hash[ability]
    end
    
    # Takes a roll string, like Athletics+Body+2, or just Athletics, parses it to figure
    # out the pieces, and then makes the roll.
    def self.parse_and_roll(client, char, roll_str)
      if (roll_str.is_integer?)
        die_result = FS3Skills.roll_dice(roll_str.to_i)
      else
        roll_params = FS3Skills.parse_roll_params roll_str
        if (roll_params.nil?)
          client.emit_failure t('fs3skills.unknown_roll_params')
          return nil
        end
        die_result = FS3Skills.roll_ability(client, char, roll_params)
      end
      die_result
    end
    
    # Parses a roll string in the form Ability+Attribute(+ or -)Modifier, where
    # everything except "Ability" is optional.
    # Technically it can be Ability+Ability, or Attribute+Attribute or Attribute+Ability;
    # the code doesn't care.
    def self.parse_roll_params(str)
      match = /^(?<ability>[^\+\-]+)\s*(?<ruling_attr>[\+]\s*[A-Za-z\s]+)?\s*(?<modifier>[\+\-]\s*\d+)?$/.match(str)
      return nil if match.nil?
      
      {
        :ability => match[:ability].strip,
        :modifier => match[:modifier].nil? ? 0 : match[:modifier].gsub(/\s+/, "").to_i,
        :ruling_attr => match[:ruling_attr].nil? ? nil : match[:ruling_attr][1..-1].strip
      }
    end
    
    def self.emit_results(message, client, room, is_private)
      if (is_private)
        client.emit message
      else
        room.emit message
      end
      Global.client_monitor.logged_in_clients.each do |c|
        next if c == client
        if (FS3Skills.receives_roll_results?(c.char) && (c.room != room || is_private))
          c.emit message
        end
      end
      Global.logger.info "FS3 roll results: #{message}"
    end
    
    def self.print_dice(dice)
      dice.sort.reverse.map { |d| d > 6 ? "%xg#{d}%xn" : d}.join(" ")
    end
    
    # Given one of the FS3 data attributes (like char.fs3_attributes or char.fs3_action_skills,
    # it will find the specified ability and update its rating (adding it if it wasn't there
    # already)
    def self.update_hash(hash, name, rating)
      if (rating == 0)
        hash.delete name
      else
        if (hash.has_key?(name))
          hash[name]["rating"] = rating
        else
          hash[name] = { "rating" => rating }
        end
      end
    end
    
    # Checks to make sure an ability name doesn't have any funky characters in it.
    def self.check_ability_name(ability)
      return t('fs3skills.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end
    
    def self.check_rating(ability_type, rating)
      max_rating = get_max_rating(ability_type)
      min_rating = get_min_rating(ability_type)

      return t('fs3skills.max_rating_is', :rating => max_rating) if (rating > max_rating)
      return t('fs3skills.min_rating_is', :rating => min_rating) if (rating < min_rating)
      return nil
    end
    
  end
end