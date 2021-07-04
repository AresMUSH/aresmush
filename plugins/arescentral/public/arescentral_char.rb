module AresMUSH
  class Character
    def alts
      # Note - includes the original character
      AresCentral.alts(self)
    end
  end
  
  class Handle
    attribute :profile
  end
end