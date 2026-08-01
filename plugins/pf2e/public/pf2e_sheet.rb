module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level,         :type => DataType::Integer, :default => 1
    attribute :ancestry
    attribute :heritage
    attribute :background
    attribute :charclass,     :type => DataType::Hash,    :default => {}

    # Stage A lock: once true, ancestry/heritage/background/class cannot change
    # without cg/reset (chargen only; blocked for approved characters).
    attribute :identity_locked, :type => DataType::Boolean, :default => false

    attribute :ability_boosts, :type => DataType::Hash, :default => {}
    attribute :background_skill_picks, :type => DataType::Array, :default => []

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
