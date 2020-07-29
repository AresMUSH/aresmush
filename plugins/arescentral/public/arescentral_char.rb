module AresMUSH
  class Character
    def alts
      AresCentral.alts(self)
    end
  end
  
  class Handle
    attribute :profile
  end
end