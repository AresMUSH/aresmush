module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level,         :type => DataType::Integer, :default => 1
    attribute :ancestry
    attribute :heritage
    attribute :background
    attribute :charclass,     :type => DataType::Hash,    :default => {}

    # Stage A lock
    attribute :identity_locked, :type => DataType::Boolean, :default => false

    attribute :ability_boosts, :type => DataType::Hash, :default => {}
    attribute :background_skill_picks, :type => DataType::Array, :default => []

    attribute :languages,     :type => DataType::Array,   :default => []

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
    attribute :feat_slot_map, :type => DataType::Hash,    :default => {}

    # Automatic ancestry/class features
    attribute :features,      :type => DataType::Array,   :default => []

    # Archetype dedications taken (slugs from archetypes.yml)
    attribute :archetypes,    :type => DataType::Array,   :default => []

    # -------------------------------------------------
    # Wealth & gear
    # money          — coins on person (count toward encumbrance when enabled)
    # society_account — Hall ledger; PC-owned; not coin; not encumbrance
    # inventory      — array of item instance hashes (see inventory.rb)
    # item_seq       — monotonic id counter for unique instances
    # -------------------------------------------------
    attribute :money,           :type => DataType::Hash,  :default => {
      "pp" => 0, "gp" => 0, "sp" => 0, "cp" => 0
    }
    attribute :society_account, :type => DataType::Hash,  :default => {
      "pp" => 0, "gp" => 0, "sp" => 0, "cp" => 0
    }
    attribute :inventory,       :type => DataType::Array, :default => []
    attribute :item_seq,        :type => DataType::Integer, :default => 0

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
