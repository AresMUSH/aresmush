module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}
    attribute :relationships_category_order, :type => DataType::Array, :default => []
    attribute :profile_image
    attribute :profile_icon
    attribute :profile_gallery, :type => DataType::Array, :default => []
    attribute :profile_last_edited, :type => DataType::Time
    attribute :profile_tags, :type => DataType::Array, :default => []
    
    collection :profile_versions, "AresMUSH::ProfileVersion"
    
    before_delete :delete_versions
    
    def delete_versions
      self.profile_versions.each { |v| v.delete }
    end
    
    def last_profile_version
      self.profile_versions.to_a.sort_by { |p| p.created_at }.reverse.first
    end
    
    def build_profile_version
      profile_text = ""
      self.demographics.each { |k, v| profile_text << "\n#{k}: #{v}"}
      self.groups.each { |k, v| profile_text << "\n#{k}: #{v}"}
      self.profile.each { |k, v| profile_text << "\n\n#{k}\n------\n#{v}"}
      self.relationships.each { |k, v| profile_text << "\n\n#{k}: #{v['category']}\n------\n#{v['relationship']}"}
      profile_text
    end
    
    def set_profile(new_profile, enactor)
      self.update(profile: new_profile)
      self.update(profile_last_edited: Time.now)
      ProfileVersion.create(character: self, text: build_profile_version, author: enactor)
    end
  end
  
end