module AresMUSH
  class Character
    attribute :background
    attribute :is_approved, DataType::Boolean
    reference :chargen_info, "AresMUSH::ChargenInfo"
    
    before_delete :delete_chargen_info
    
    def delete_chargen_info
      self.chargen_info.delete if self.chargen_info
    end
    
    def get_or_create_chargen_info
      info = self.chargen_info
      if (!info)
        info = ChargenInfo.create(character: self)
        self.update(chargen_info: info)
      end
      info
    end
  end
  
  class ChargenInfo < Ohm::Model
    include ObjectModel
    
    attribute :locked, DataType::Boolean
    attribute :current_stage, DataType::Integer
    reference :approval_job, "AresMUSH::Job"
    
    reference :character, "AresMUSH::Character"
  end
end