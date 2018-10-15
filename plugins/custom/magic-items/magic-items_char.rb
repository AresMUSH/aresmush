module AresMUSH
  class Character < Ohm::Model
    collection :magic_item, "AresMUSH::PotionsHas"
    attribute :magic_item_equipped, :default => "None"
    end
end

  class MagicItem < Ohm::Model
    include ObjectModel
    attribute :name
    index :name
    reference :character, "AresMUSH::Character"
    attribute :description
    attribute :spell
    attribute :weapon_specials
    attribute :armor_specials

  end
