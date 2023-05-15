module AresMUSH
  module Scenes

    def self.custom_char_card_fields(char, viewer)

      spells = Magic.spell_list_all_data(char.spells_learned)
      return {
        abilities: Scenes.char_fs3_abilities(char),
        major_spells: Magic.major_school_spells(char, spells),
        minor_spells: Magic.minor_school_spells(char, spells),
        other_spells: Magic.other_spells(char, spells),
        major_school: char.major_schools.first,
        minor_school: char.minor_schools.first,
        magic_items: Magic.get_magic_items(char),
        potions: Magic.get_potions(char),
        potions_creating: Magic.get_potions_creating(char),
        bonded: !char.bonded.nil?,
        mythic_name: char.bonded&.name,
        mythic_type: char.bonded&.expanded_mount_type,
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

    def self.spell_list(char)
      spells = []
      spells_learned = char.spells_learned.select { |l| l.learning_complete }
      spells_learned.each do |s|
        spells << s.name
      end
      item_spells = Magic.item_spells(char)
      item_spells.each do |s|
        spells << s
      end
      spells = spells.sort
      return spells
    end


  end
end
