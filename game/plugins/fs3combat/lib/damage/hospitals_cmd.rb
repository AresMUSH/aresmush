module AresMUSH
  module FS3Combat
    class HospitalsCmd
      include CommandHandler
      
      def handle
        hospitals = Room.find(is_hospital: true)
        list = hospitals.map { |h| h.name }
        
        template = BorderedListTemplate.new list, t('fs3combat.hospitals_title')
        client.emit template.render
      end
    end
  end
end