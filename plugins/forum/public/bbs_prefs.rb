module AresMUSH  
  class Character 
    attribute :forum_muted, :type => DataType::Boolean
    collection :bbs_prefs, "AresMUSH::BbsPrefs"
    
    before_delete :delete_bbs_prefs
    
    def is_forum_muted?
      self.forum_muted
    end
    
    def delete_bbs_prefs
      self.bbs_prefs.each { |p| p.destroy }
    end
    
  end
  
  class BbsPrefs < Ohm::Model
    include ObjectModel
            
    reference :character, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    
    index :bbs_board
    
    attribute :hidden, :type => DataType::Boolean
    
  end
end
