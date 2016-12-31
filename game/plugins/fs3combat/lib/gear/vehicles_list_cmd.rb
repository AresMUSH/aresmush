module AresMUSH
  module FS3Combat
    class VehiclesListCmd
      include CommandHandler
      include TemplateFormatters
      
      def handle
        template = GearListTemplate.new FS3Combat.vehicles, t('fs3combat.vehicles_title')
        client.emit template.render
      end
    end
  end
end