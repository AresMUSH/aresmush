module AresMUSH
  # TODO - REDO
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == "me")

      room = client.room
      if (name.downcase == "here")        
        return FindResult.new(room, nil)
      end

      contents = room.clients.select { |c| c.char.name_upcase == name.upcase }
      # TODO - Returns a client, should it return the char instead?
      SingleResultSelector.select(contents)
    end
  end
end