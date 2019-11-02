module AresMUSH
  module Who
    def self.all_online
      who = []
      Global.client_monitor.logged_in.each do |client, char|
        who << char
      end
      Global.client_monitor.web_clients.each do |client|
        char = Character[client.web_char_id]
        next if !char
        who << char
      end
      who.uniq
    end
    
    # This is how the room name is displayed.  It is also used for
    # sorting purposes, so characters are sorted by area then individual rooms,
    # and unfindable characters are sorted together.
    def self.who_room_name(char)
      if (char.who_hidden)
        return t('who.hidden')
      end
      
      if Login.is_portal_only?(char)
        return t('who.web_room')
      end
      
      room_area = char.room.area_name
      room_grid = char.room.grid_marker
      
      grid = room_grid ? " #{room_grid}" : ""
      area = room_area ? "#{room_area} - " : ""
      "#{area}#{char.room.name}#{grid}"
    end
  end
end