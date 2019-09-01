module AresMUSH
  module Places
    class PlaceLeaveCmd
      include CommandHandler
      
      def handle
        place = enactor.place(enactor_room)
        
        if (!place)
          client.emit_failure t('places.not_in_place')
          return
        end
        
        Places.leave_place(enactor, place)
      end
    end
  end
end
