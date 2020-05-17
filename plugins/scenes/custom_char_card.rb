module AresMUSH
  module Scenes

    def self.custom_char_card_fields(char, viewer)

      schools = char.groups.map { |k, v| { school_type: k, school_name: v } }

      # Return nil if you don't need any custom fields.
      # return nil

      # Otherwise return a hash of data.  For example, if you want to show traits you could do:
      # {
      #   traits: char.traits.map { |k, v| { name: k, description: v } }
      # }
    end
  end
end
