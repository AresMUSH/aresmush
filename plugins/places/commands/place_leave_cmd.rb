module AresMUSH
  module Places
    class PlaceLeaveCmd
      include CommandHandler
      
      def check_in_place
        return t('places.not_in_place') if !enactor.place
        return nil
      end
      
      def handle
        place_name = enactor.place.name
        enactor.update(place: nil)
        Rooms.emit_ooc_to_room(enactor_room, t('places.left_place', :name => enactor.name, :place_name => place_name))
      end
    end
  end
end
