module AresMUSH
  class Character
    attribute :ooctime_timezone
    
    before_create :set_default_timezone
    
    def set_default_timezone
      self.ooctime_timezone = Global.read_config("ooctime", "default_timezone")
    end
  end
end