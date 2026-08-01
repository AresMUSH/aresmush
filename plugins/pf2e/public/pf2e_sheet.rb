module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level, :default => 1
    attribute :ancestry
    attribute :heritage
    attribute :charclass, :default => {}

    # Abilities: [base, current]
    attribute :abilities, :default => {
      "str" => [10, 10],
      "dex" => [10, 10],
      "con" => [10, 10],
      "int" => [10, 10],
      "wis" => [10, 10],
      "cha" => [10, 10]
    }

    # Skills & saves (sparse — missing key = Untrained)
    # Perception lives in saves
    attribute :skills, :default => {}
    attribute :saves, :default => {}

    # Feats (list of slugs)
    attribute :feats, :default => []

    # Combat / resources
    attribute :hp, :default => {
      "current" => 0,
      "max"     => 0,
      "temp"    => 0
    }
    attribute :focus_points, :default => 0
    attribute :hero_points, :default => 1
    attribute :speed, :default => 25
    attribute :conditions, :default => {}

    # Magic (keyed by source: "wizard", "druid-dedication", etc.)
    attribute :magic, :default => {}
  end
end
