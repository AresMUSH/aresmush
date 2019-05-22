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
