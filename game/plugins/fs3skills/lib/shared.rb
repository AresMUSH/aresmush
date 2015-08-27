module AresMUSH
  module FS3Skills
    def self.receives_roll_results?(char)
      char.has_any_role?(Global.read_config("fs3skills", "roles", "receives_roll_results"))
    end
    
    def self.can_manage_abilities?(actor)
      actor.has_any_role?(Global.read_config("fs3skills", "roles", "can_manage_abilities"))
    end

    def self.aptitudes
      Global.read_config("fs3skills", "aptitudes")
    end
    
    def self.action_skills
      Global.read_config("fs3skills", "action_skills")
    end 
    
    def self.advantages
      Global.read_config("fs3skills", "advantages")
    end 

    def self.languages
      Global.read_config("fs3skills", "languages")
    end
    
    def self.aptitude_names
      aptitudes.map { |a| a['name'].titleize }
    end
    
    def self.action_skill_names
      action_skills.map { |a| a['name'].titleize }
    end
    
    def self.advantages_names
      advantages.map { |a| a['name'].titleize }
    end

    # Expects titleized ability name
    # Returns the type (aptitude, action, etc) for a skill being rolled.
    def self.get_ability_type(char, ability)
      if (aptitude_names.include?(ability))
        return :aptitude
      elsif (action_skill_names.include?(ability))
        return :action
      elsif (advantages_names.include?(ability))
        return :advantage
      elsif (char.fs3_expertise.include?(ability))
        return :expertise
      elsif (char.fs3_interests.include?(ability))
        return :interest
      else
        return :nonexistant
      end        
    end
    
    # Gets the appropriate data hash from the character object based on
    # the ability type.  This can be used to look up or set a rating.
    def self.get_ability_hash_for_type(char, ability_type)
      case ability_type
      when :aptitude
        char.fs3_aptitudes
      when :action
        char.fs3_action_skills
      when :advantage
        char.fs3_advantages
      else
        raise "Invalid ability type requested: #{ability_type}."
      end
    end
    
    def self.get_ability_list_for_type(char, ability_type)
      case ability_type
      when :language
        char.fs3_languages
      when :interest
        char.fs3_interests
      when :expertise
        char.fs3_expertise
      else
        raise "Invalid ability type requested: #{ability_type}."
      end
    end
    
    def self.get_max_rating(ability_type)
      5
    end
    
    def self.get_min_rating(ability_type)
      0
    end
    
    
    def self.dice_to_roll_for_ability(char, roll_params)
      ability = roll_params.ability
      modifier = roll_params.modifier || 0

      ability_type = FS3Skills.get_ability_type(char, ability)
      skill_rating = FS3Skills.ability_rating(char, ability)

      case ability_type
      when :aptitude, :nonexistant
        # Don't double-count aptitude rating when defaulting.
        related_apt = "None"
        apt_rating = 0
      else
        related_apt = roll_params.related_apt || FS3Skills.get_related_apt(char, ability)
        apt_rating = FS3Skills.ability_rating(char, related_apt)
      end
      
      dice = (skill_rating * 2) + apt_rating + modifier

      Global.logger.debug "#{char.name} rolling #{ability} mod=#{modifier} skill=#{skill_rating} related_apt=#{related_apt} apt=#{apt_rating}"
      
      dice
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
    
    # Parses a roll string in the form Ability+Aptitude(+ or -)Modifier, where
    # everything except "Ability" is optional.
    # Technically it can be Ability+Ability, or Attribute+Aptitude or Aptitude+Ability;
    # the code doesn't care.
    def self.parse_roll_params(str)
      match = /^(?<ability>[^\+\-]+)\s*(?<related_apt>[\+]\s*[A-Za-z\s]+)?\s*(?<modifier>[\+\-]\s*\d+)?$/.match(str)
      return nil if match.nil?
      
      ability = match[:ability].strip
      modifier = match[:modifier].nil? ? 0 : match[:modifier].gsub(/\s+/, "").to_i
      related_apt = match[:related_apt].nil? ? nil : match[:related_apt][1..-1].strip
      
      return RollParams.new(ability, modifier, related_apt)
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
    
    # Given one of the FS3 data attributes (like char.fs3_aptitudes or char.fs3_action_skills,
    # it will find the specified ability and update its rating (adding it if it wasn't there
    # already)
    def self.update_hash(hash, name, rating)
      if (rating == 0)
        hash.delete name
      else
        hash[name] = rating
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