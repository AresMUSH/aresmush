module AresMUSH
  class Character
    attribute :profile, :type => DataType::Hash, :default => {}   
    attribute :relationships, :type => DataType::Hash, :default => {}
    attribute :relationships_category_order, :type => DataType::Array, :default => []
    attribute :profile_image
    attribute :profile_icon
    attribute :profile_last_edited, :type => DataType::Time
    attribute :profile_tags, :type => DataType::Array, :default => []
    attribute :profile_gallery, :type => DataType::Array, :default => []
    attribute :profile_order, :type => DataType::Array, :default => []
    
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
      (Profile.character_page_files(self) || []).sort.each { |k| profile_text << "\n\nGallery: #{k}"}
      profile_text
    end
    
    def set_profile(new_profile, enactor)
      self.update(profile: new_profile)
      self.update(profile_last_edited: Time.now)

      history_text = build_profile_version
      if (last_profile_version && last_profile_version.text == history_text)
        return
      end
      version = ProfileVersion.create(character: self, text: history_text, author: enactor)
      Website.add_to_recent_changes('char', t('profile.profile_updated', :name => self.name), { version_id: version.id, char_name: self.name }, enactor.name)
    end
  end
  
end