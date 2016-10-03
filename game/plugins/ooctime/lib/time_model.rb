module AresMUSH
  class Character
    attribute :timezone
    
    before_create :set_timezone
    
    def set_timezone
      self.timezone = "America/New_York"
    end
  end
end