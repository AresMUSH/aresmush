module AresMUSH
  module Rooms
    def self.find_visible_object(name, client)
      if (name == t("rooms.me"))
        client.player
      elsif (name == t("rooms.here"))
        Room.find_one_and_notify(client.player["location"], client)
        # TODO - Add searches for exits and contents
      end
    end    
  end
end