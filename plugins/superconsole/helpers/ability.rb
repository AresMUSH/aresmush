module AresMUSH
  module SuperConsole

    def self.attrs
      Global.read_config("superconsole", "attributes")
    end

    def self.attr_names
      attrs.map { |a| a['name'].titlecase }
    end

    def self.set_ability(char, ability_name, rating)
      ConsoleAttribute.create(character: char, name: ability_name, rating: rating, favored: false, unfavored: false)
    end

    def self.check_ability_name(ability)
      return t('SuperConsole.no_special_characters') if (ability !~ /^[\w\s]+$/)
      return nil
    end

    def self.update_ability(char,ability_name,field,value)
      ability_name = ability_name ? ability_name.titleize : nil
      error = SuperConsole.check_ability_name(ability_name)
      if (error)
        return error
      end
      ability_type = FS3Skills.get_ability_type(ability_name)
      ability = FS3Skills.find_ability(char, ability_name)
      if (ability)
        case ability_type
        when :attribute
          case field
          when rating
            ability.update(rating: value)
          when favored
            ability.update(favored: value)
          when unfavored
            ability.update(unfavored: value)
          else
            t('superconsole.update_error_attribute', :name => ability_name, :field => field)
        end
      else
        t('superconsole.set_ability', :name => ability_name)
    end


    def self.get_ability_type(ability)
      ability = ability.titlecase
      if (attr_names.include?(ability))
        return :attribute
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
