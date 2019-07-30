module AresMUSH
  module Places
    def self.join_place(char, place)
      message = t('places.place_joined', :name => char.name, :place_name => place.name)
      room = place.room
      scene = room.scene

      old_place = room.places.select { |p| p.characters.include?(char) }.first
      if (old_place)
        Places.leave_place(char, old_place)
      end
        
      place.characters.add char
      
      room.emit_ooc message
      if (scene)
        Scenes.add_to_scene(scene, message)
      end
    end
    
    def self.leave_place(char, place)
      message = t('places.left_place', :name => char.name, :place_name => place.name)
      place.characters.delete char
      
      room = place.room
      scene = room.scene
      
      room.emit_ooc message
      if (scene)
        Scenes.add_to_scene(scene, message)
      end
    end
  end
end