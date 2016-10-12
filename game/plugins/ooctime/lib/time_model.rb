module AresMUSH
  class Character
    attribute :ooctime_timezone
    
    default_values :default_timezone
    
    def self.default_timezone
      { ooctime_timezone: Global.read_config("ooctime", "default_timezone") }
    end
  end
end