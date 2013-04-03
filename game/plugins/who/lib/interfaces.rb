module AresMUSH
  module Who

    # TODO - move to interfaces
    def self.is_ic?(player)
      player["status"] == "IC"
    end

  end
end