module AresMUSH
  module FS3Skills
    
    def self.dice_to_roll_for_ability(char, roll_params)
      ability = roll_params.ability
      modifier = roll_params.modifier || 0

      linked_attr = roll_params.linked_attr || FS3Skills.get_linked_attr(ability)
      
      skill_rating = FS3Skills.ability_rating(char, ability)
      ability_type = FS3Skills.get_ability_type(ability)
      
      # Language doubles dice except 0 = 0
      if (ability_type == :language)
        skill_rating = skill_rating == 0 ? 0 : skill_rating * 2
      # Background doubles dice, but an untrained one defaults to everyman (1)
      elsif (ability_type == :background)
        skill_rating = skill_rating == 0 ? 1 : skill_rating * 2
      elsif (ability_type == :attribute && !linked_attr)
        skill_rating = 1
        linked_attr = ability
      end
      
      apt_rating = linked_attr ? FS3Skills.ability_rating(char, linked_attr) : 0
      
      dice = skill_rating + apt_rating + modifier
      Global.logger.debug "#{char.name} rolling #{ability} mod=#{modifier} skill=#{skill_rating} linked_attr=#{linked_attr} apt=#{apt_rating}"
      
      dice
    end
    
    
    # Takes a roll string, like Athletics+Body+2, or just Athletics, parses it to figure
    # out the pieces, and then makes the roll.
    def self.parse_and_roll(client, char, roll_str)
      if (roll_str.is_integer?)
        dice = (roll_str.to_i) + 2
        die_result = FS3Skills.roll_dice(dice)
      else
        roll_params = FS3Skills.parse_roll_params roll_str
        if (!roll_params)
          client.emit_failure t('fs3skills.unknown_roll_params')
          return nil
        end
        die_result = FS3Skills.roll_ability(client, char, roll_params)
      end
      die_result
    end
    
    # Parses a roll string in the form Ability+Attr(+ or -)Modifier, where
    # everything except "Ability" is optional.
    # Technically it can be Ability+Ability, or Attribute+Attribute or Attribute+Ability;
    # the code doesn't care.
    def self.parse_roll_params(str)
      match = /^(?<ability>[^\+\-]+)\s*(?<linked_attr>[\+]\s*[A-Za-z\s]+)?\s*(?<modifier>[\+\-]\s*\d+)?$/.match(str)
      return nil if !match
      
      ability = match[:ability].strip
      modifier = match[:modifier].nil? ? 0 : match[:modifier].gsub(/\s+/, "").to_i
      linked_attr = match[:linked_attr].nil? ? nil : match[:linked_attr][1..-1].strip
      
      return RollParams.new(ability, modifier, linked_attr)
    end
    
  end
end