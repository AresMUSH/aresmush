module AresMUSH
  module SuperConsole

    def self.attrs
      Global.read_config("superconsole", "attributes")
    end

    def self.attr_names
      attrs.map { |a| a['name'].titlecase }
    end

    def self.abilities
      Global.read_config("superconsole", "abilities")
    end

    def self.abilities_name
      abilities.map { |a| a['name'].titlecase}
    end

    def self.get_min_rating(ability_type)
      case ability_type
      when :ability
        min_rating = 0
      when :attribute
        min_rating = 1
      end
      min_rating
    end

    def self.set_ability(char, ability_name, rating)
      ability_name = ability_name ? ability_name.titleize : nil
      error = SuperConsole.check_ability_name(ability_name)
      if (error)
        return error
      end
      ability_type = SuperConsole.get_ability_type(ability_name)

      min_rating = SuperConsole.get_min_rating(ability_type)
      ability = SuperConsole.find_ability(char, ability_name)

      if (ability)
        ability.update(rating: rating)
      else
        case ability_type
        when :attribute
          ability = ConsoleAttribute.create(character: char, name: ability_name, rating: rating, masterpoints: 0, learnpoints: 0, learnable: true)
        when :ability
          ability = ConsoleAbility.create(character: char, name: ability_name, rating: rating, masterpoints: 0, learnpoints: 0, learnable: true)
        end
      end
      if (rating == min_rating)
        if (ability && (ability_type == :ability))
          ability.delete
        end
      end
      return nil
    end

    def self.check_ability_name(ability)
      return t('SuperConsole.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end

    def self.set_favor(c,a)
      ability_name = a.titlecase
      ability_type = SuperConsole.get_ability_type(a)
      ab = SuperConsole.find_ability(c,a)
      if ability_type == :attribute
        if ab.favored == true
          ab.update(favored: false)
        elsif ab.favored == false
          ab.update(favored: true)
        else
          nil
        end
      else
        "You can only mark attributes as favored."
      end
    end

    def self.set_unfavor(c,a)
      ability_name = a.titlecase
      ability_type = SuperConsole.get_ability_type(a)
      ab = SuperConsole.find_ability(c,a)
      if ability_type == :attribute
        if ab.unfavored == true
          ab.update(unfavored: false)
        elsif ab.unfavored == false
          ab.update(unfavored: true)
        else
          nil
        end
      else
        "You can only mark attributes as unfavored."
      end
    end

    def self.get_ability_type(ability)
      ability = ability.titlecase
      if (attr_names.include?(ability))
        return :attribute
      elsif (abilities_name.include?(ability))
        return :ability
      else
        nil
      end
    end

    def self.find_ability(char, ability_name)
      ability_name = ability_name.titlecase
      ability_type = SuperConsole.get_ability_type(ability_name)
      case ability_type
      when :attribute
        char.console_attributes.find(name: ability_name).first
      when :ability
        char.console_skills.find(name: ability_name).first
      else
        nil
      end
    end

    def self.ability_rating(char, ability_name)
      ability = SuperConsole.find_ability(char, ability_name)
      ability ? ability.rating : 0
    end
  end
end
