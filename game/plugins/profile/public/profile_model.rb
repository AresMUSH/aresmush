module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}
    attribute :relationships_category_order, :type => DataType::Array, :default => []
  end
end