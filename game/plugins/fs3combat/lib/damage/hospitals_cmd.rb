module AresMUSH
  module FS3Combat
    class HospitalsCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        hospitals = Room.find(is_hospital: true)
        list = hospitals.map { |h| h.name }
        client.emit BorderedDisplay.list list, t('fs3combat.hospitals_title')
      end
    end
  end
end