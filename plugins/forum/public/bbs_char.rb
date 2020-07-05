module AresMUSH
  class Character 
    attribute :forum_muted, :type => DataType::Boolean

    # OBSOLETE - use read_tracker instead
    attribute :forum_read_posts, :type => DataType::Array, :default => []
    
    collection :bbs_prefs, "AresMUSH::BbsPrefs"
    
    before_delete :delete_bbs_prefs
  
    def is_forum_muted?
      self.forum_muted
    end
  
    def delete_bbs_prefs
      self.bbs_prefs.each { |p| p.delete }
    end
  end
end