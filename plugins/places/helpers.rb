module AresMUSH
  module Places
    def self.join_place(char, place)
      message = t('places.place_joined', :name => char.name, :place_name => place.name)
      char.update(place: place)
      char.room.emit_ooc message
      if (char.room.scene)
        Scenes.add_to_scene(char.room.scene, message)
      end
    end
  end
end