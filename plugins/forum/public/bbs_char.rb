module AresMUSH
  class Character 
    attribute :forum_muted, :type => DataType::Boolean
    attribute :forum_read_posts, :type => DataType::Array, :default => []
    
    collection :bbs_prefs, "AresMUSH::BbsPrefs"
    
    before_delete :delete_bbs_prefs
  
    def is_forum_muted?
      self.forum_muted
    end
  
    def delete_bbs_prefs
      self.bbs_prefs.each { |p| p.destroy }
    end
  end
end