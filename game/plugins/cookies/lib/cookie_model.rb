module AresMUSH
  class Character
    def cookies_received
      CookieAward.find(recipient_id: self.id)
    end
    
    def cookies_given
      CookieAward.find(giver_id: self.id)
    end
  end
  
  class CookieAward < Ohm::Model
    include ObjectModel
    
    reference :giver, "AresMUSH::Character"
    reference :recipient, "AresMUSH::Character"
  end
end