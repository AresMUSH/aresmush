module AresMUSH
  module Status
    def self.custom_ic_start_location(char)
      # If you don't want any custom IC starting locations, just return nil
      nil
      
      # Otherwise return a room based on the character's information.
      # For example, if everyone from the "Martian" faction starts out in a room named "Mars Promenade" you could do:
      #
      #    faction = char.group("Faction")
      #    if (faction == "Martian")
      #       return Room.named("Mars Promenade")
      #    else
      #       return Room.named("Geneva Starport")
      #    end
    end
  end
end