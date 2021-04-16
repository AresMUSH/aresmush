module AresMUSH
  module Scenes

    def self.custom_char_card_fields(char, viewer)



      {
        schools:char.groups.map { |k, v| { school_type: k.titlecase, school_name: v } },
        abilites: self.char_fs3_abilities(char)
      }





      # Return nil if you don't need any custom fields.
      # return nil

      # Otherwise return a hash of data.  For example, if you want to show traits you could do:
      # {
      #   traits: char.traits.map { |k, v| { name: k, description: v } }
      # }
    end

    def self.char_fs3_abilities(char)
      abilities = []
      [ char.fs3_attributes, char.fs3_action_skills, char.fs3_background_skills, char.fs3_languages, char.fs3_advantages ].each do |list|
        list.each do |a|
          abilities << a.name
        end
        return abilities
      end
    end

  end
end
