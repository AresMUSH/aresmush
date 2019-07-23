module AresMUSH
  class Character < Ohm::Model
    attribute :magic_items, :type => DataType::Array, :default => []
    attribute :magic_item_equipped, :default => "None"
  end
end
