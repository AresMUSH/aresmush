module AresMUSH
  class Character < Ohm::Model
   # Collection Attributes
    collection :fs3_magix_items, "AresMUSH::MagicItems"
    collection :fs3_magix_spells_learned, "AresMUSH::SpellsLearned"

  # Attributes -- attributes.
    attribute :fs3_magix_equipped_1, :default => "None"
    attribute :fs3_magix_equipped_2, :default => "None"
    attribute :fs3_magix_spells_cast, :type => DataType::Integer
    attribute :fs3_magix_achievement_spells_learned, :type => DataType::Integer
    attribute :fs3_magix_last_learned, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
  end


  class MagicItems < Ohm::Model
    include ObjectModel
    attribute :name
    index :name
    reference :character, "AresMUSH::Character"
    attribute :desc
    attribute :spell
    attribute :weapon_specials
    attribute :armor_specials
    attribute :item_spell_mod
    attribute :item_attack_mod
  end

  class SpellsLearned < Ohm::Model
    include ObjectModel
    attribute :name
    index :name
    attribute :last_learned, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
    reference :character, "AresMUSH::Character"
    attribute :level, :type => DataType::Integer
    attribute :xp_needed, :type => DataType::Integer
    attribute :learning_complete, :type => DataType::Boolean
    attribute :school
    attribute :time_to_next_learn_spell
  end

  def can_learn?
    self.time_to_next_learn <= 0
  end

  def time_to_next_learn
    return 0 if !self.fs3_magix_last_learned
    time_left = (FS3Magix.days_between_learning * 86400) - (Time.now - self.fs3_magix_last_learned)
    [time_left, 0].max
  end
end
