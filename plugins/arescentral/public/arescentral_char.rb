module AresMUSH
  class Character
    def alts
      AresCentral.alts(self)
    end
  end
end