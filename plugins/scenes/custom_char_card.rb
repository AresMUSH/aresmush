module AresMUSH
  module Scenes

    def self.custom_char_card_fields(char, viewer)



      {
        schools:char.groups.map { |k, v| { school_type: k.titlecase, school_name: v } },
        abilities: Scenes.char_fs3_abilities(char)
      }





      # Return nil if you don't need any custom fields.
      # return nil

      # Otherwise return a hash of data.  For example, if you want to show traits you could do:
      # {
      #   traits: char.traits.map { |k, v| { name: k, description: v } }
      # }
    end

    def self.char_fs3_abilities(char)
      damage = char.damage.to_a.sort { |d| d.created_at }.map { |d| {
        date: d.ictime_str,
        description: d.description,
        original_severity: MushFormatter.format(FS3Combat.display_severity(d.initial_severity)),
        severity: MushFormatter.format(FS3Combat.display_severity(d.current_severity))
        }}

      {
      attributes: self.get_ability_list(char.fs3_attributes),
      action_skills: self.get_ability_list(char.fs3_action_skills, true),
      backgrounds: self.get_ability_list(char.fs3_background_skills),
      languages: self.get_ability_list(char.fs3_languages),
      damage: damage,
      luck_points: char.luck.floor,
      }
    end

    def self.get_ability_list(list, include_specs = false)
      new_list = []
      list.to_a.each do |a|
        if a.rating > 0
          new_list << a
        end
      end

      new_list.sort_by { |a| a.name }.map { |a|
        {
          name: a.name,
          rating: a.rating,
          rating_name: a.rating_name,
        }}
    end


  end
end
