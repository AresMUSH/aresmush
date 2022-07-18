module AresMUSH  
  class BbsPrefs < Ohm::Model
    include ObjectModel
            
    reference :character, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    
    index :bbs_board
    
    attribute :hidden, :type => DataType::Boolean
    
  end
end
