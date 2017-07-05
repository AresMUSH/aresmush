module AresMUSH
  class Character
    attribute :ooctime_timezone, :default => "America/New_York"

    def timezone
      self.ooctime_timezone
    end
    
    def timezone=(tz)
      self.ooctime_timezone = tz
    end
  end
end