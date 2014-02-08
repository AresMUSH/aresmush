module AresMUSH
  module Who

    # TODO - Move to IC Module
    def self.is_ic?(char)
      char["status"] == "IC"
    end
    
    def self.online_record
      game = Game.get
      count = game["online_record"]
    end
    
    def self.online_record=(value)
      game = Game.get
      game["online_record"] = value
      Game.update(game)
    end

  end
end