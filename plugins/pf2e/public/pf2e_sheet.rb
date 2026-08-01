module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level,         :type => DataType::Integer, :default => 1
    attribute :ancestry
    attribute :heritage
    attribute :background
    attribute :charclass,     :type => DataType::Hash,    :default => {}

    # Free ability boost picks by source (slug lists).
    attribute :ability_boosts, :type => DataType::Hash, :default => {}

    # Resolved background skill_choices, in choice-index order.
    # e.g. ["warfare_lore"] or ["forest_lore"]
    attribute :background_skill_picks, :type => DataType::Array, :default => []

    # Abilities: [base, current]
    attribute :abilities,     :type => DataType::Hash,    :default => {
      "str" => [10, 10],
      "dex" => [10, 10],
      "con" => [10, 10],
      "int" => [10, 10],
      "wis" => [10, 10],
      "cha" => [10, 10]
    }

    attribute :skills,        :type => DataType::Hash,    :default => {}
    attribute :saves,         :type => DataType::Hash,    :default => {}
    attribute :feats,         :type => DataType::Array,   :default => []

    attribute :hp,            :type => DataType::Hash,    :default => {
      "current" => 0,
      "max"     => 0,
      "temp"    => 0
    }
    attribute :focus_points,  :type => DataType::Integer, :default => 0
    attribute :hero_points,   :type => DataType::Integer, :default => 1
    attribute :speed,         :type => DataType::Integer, :default => 25
    attribute :conditions,    :type => DataType::Hash,    :default => {}
    attribute :magic,         :type => DataType::Hash,    :default => {}
  end
end
