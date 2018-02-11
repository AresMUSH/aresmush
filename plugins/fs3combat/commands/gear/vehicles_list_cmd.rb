module AresMUSH
  module FS3Combat
    class VehiclesListCmd
      include CommandHandler
      
      def check_vehicles_allowed
        return t('fs3combat.vehicles_disabled') if !FS3Combat.vehicles_allowed?
        return nil
      end
      
      def handle
        template = GearListTemplate.new FS3Combat.vehicles, t('fs3combat.vehicles_title')
        client.emit template.render
      end
    end
  end
end