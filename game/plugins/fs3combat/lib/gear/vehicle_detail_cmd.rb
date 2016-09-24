module AresMUSH
  module FS3Combat
    class VehicleDetailCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'vehicles'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_vehicle_exists
        return t('fs3combat.invalid_vehicle') if !FS3Combat.vehicle(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.vehicle(self.name), self.name)
        client.emit template.render
      end
    end
  end
end