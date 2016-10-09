module AresMUSH
  class Character
    attribute :timezone
    
    before_create :set_default_timezone
    
    def set_default_timezone
      self.timezone = Global.read_config("ooctime", "default_timezone")
    end
  end
end