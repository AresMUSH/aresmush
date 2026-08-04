module AresMUSH
  class Pf2eSheet < Ohm::Model
    reference :character, "AresMUSH::Character"

    # Core
    attribute :level,         :type => DataType::Integer, :default => 1
    # XP toward the *next* level (PF2e resets by subtracting threshold on level-up).
    # Not lifetime total. Default 0.
    attribute :xp,            :type => DataType::Integer, :default => 0
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

    # Sheet-side proficiency overlay (attacks/defenses bumps from advancement).
    # Effective rank = max(class root, overlay) when helpers look up categories.
    attribute :proficiencies, :type => DataType::Hash,    :default => {}

    attribute :feats,         :type => DataType::Array,   :default => []
    attribute :feat_slot_map, :type => DataType::Hash,    :default => {}

    attribute :features,      :type => DataType::Array,   :default => []
    attribute :archetypes,    :type => DataType::Array,   :default => []

    # Advancement spend ledger (unspent picks after level-up autos apply).
    # Keys: skill_increase, ability_boost, class_feat, skill_feat, general_feat, ancestry_feat
    attribute :pending_advancement, :type => DataType::Hash, :default => {}
    # Structured non-feat choices: { "weapon_group" => "swords", ... }
    attribute :advancement_picks,   :type => DataType::Hash, :default => {}

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
