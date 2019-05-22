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
  end
end
