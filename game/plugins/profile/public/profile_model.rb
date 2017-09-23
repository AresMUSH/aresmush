module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}
    attribute :relationships_category_order, :type => DataType::Array, :default => []
    attribute :profile_image
    attribute :profile_icon
    attribute :profile_gallery
    attribute :profile_last_edited, :type => DataType::Date
    attribute :profile_tags, :type => DataType::Array, :default => []
    
    def set_profile(new_profile)
      self.update(profile: new_profile)
      self.update(profile_last_edited: DateTime.now)
    end
  end
end