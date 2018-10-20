module AresMUSH
  class NPC < Ohm::Model
    collection :magic_items, "AresMUSH::MagicItems"
    attribute :magic_item_equipped, :default => "None"
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
  end
