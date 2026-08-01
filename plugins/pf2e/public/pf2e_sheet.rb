module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level,         :type => AresMUSH::DataType::Integer, :default => 1
    attribute :ancestry
    attribute :heritage
    attribute :charclass,     :type => AresMUSH::DataType::Hash,    :default => {}

    # Abilities: [base, current]
    attribute :abilities,     :type => AresMUSH::DataType::Hash,    :default => {
      "str" => [10, 10],
      "dex" => [10, 10],
      "con" => [10, 10],
      "int" => [10, 10],
      "wis" => [10, 10],
      "cha" => [10, 10]
    }

    # Skills & saves (sparse — missing key = Untrained)
    # Perception lives in saves
    attribute :skills,        :type => AresMUSH::DataType::Hash,    :default => {}
    attribute :saves,         :type => AresMUSH::DataType::Hash,    :default => {}

    # Feats (list of slugs)
    attribute :feats,         :type => AresMUSH::DataType::Array,   :default => []

    # Combat / resources
    attribute :hp,            :type => AresMUSH::DataType::Hash,    :default => {
      "current" => 0,
      "max"     => 0,
      "temp"    => 0
    }
    attribute :focus_points,  :type => AresMUSH::DataType::Integer, :default => 0
    attribute :hero_points,   :type => AresMUSH::DataType::Integer, :default => 1
    attribute :speed,         :type => AresMUSH::DataType::Integer, :default => 25
    attribute :conditions,    :type => AresMUSH::DataType::Hash,    :default => {}

    # Magic (keyed by source: "wizard", "druid-dedication", etc.)
    attribute :magic,         :type => AresMUSH::DataType::Hash,    :default => {}
  end
end
