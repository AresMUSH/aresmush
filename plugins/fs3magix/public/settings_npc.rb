module AresMUSH
  class NPC < Ohm::Model
    collection :fs3_magix_items, "AresMUSH::MagicItems"
    attribute :fs3_magix_equipped_1, :default => "None"
    attribute :fs3_magix_equipped_2, :default => "None"
  end
end

  class MagicItems < Ohm::Model
    include ObjectModel
    attribute :name
    index :name
    reference :npc, "AresMUSH::Npc"
    attribute :desc
    attribute :spell
    attribute :weapon_specials
    attribute :armor_specials
    attribute :item_spell_mod
    attribute :item_attack_mod
  end
