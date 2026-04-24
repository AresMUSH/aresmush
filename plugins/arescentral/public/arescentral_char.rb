module AresMUSH
  class Character
    attribute :unified_play_screen, :type => DataType::Boolean, :default => true

    before_delete :cleanup_handle

    def alts
      # Note - includes the original character
      AresCentral.alts(self)
    end    
    
    def cleanup_handle
      if (self.handle)
        AresCentral.unlink_handle(self)
      end
    end
  end
  
  class Handle
    attribute :profile
  end
end