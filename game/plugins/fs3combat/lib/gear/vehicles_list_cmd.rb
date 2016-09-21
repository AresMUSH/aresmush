module AresMUSH
  module FS3Combat
    class VehiclesListCmd
      include CommandHandler
      include CommandRequiresLogin
      include TemplateFormatters
      
      def handle
        template = GearTemplate.new FS3Combat.vehicles, t('fs3combat.vehicles_title'), client
        template.render
      end
    end
  end
end