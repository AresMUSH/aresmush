module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}
    attribute :relationships_category_order, :type => DataType::Array, :default => []
    attribute :profile_image
    attribute :profile_gallery
  end
end