module AresMUSH
  class Character
    
    def place(room)
      room.places.select { |p| p.characters.include?(self) }.first
    end
    
    def place_name(room)
      p = self.place(room)
      p ? p.name : nil
    end
  end
end