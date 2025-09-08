module AresMUSH
  class Character < Ohm::Model
    attribute :items, :type => DataType::Array, :default => []
    attribute :item_equipped, :default => "None"
  end
end
