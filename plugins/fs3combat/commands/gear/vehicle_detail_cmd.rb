module AresMUSH
  module FS3Combat
    class VehicleDetailCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def check_vehicles_allowed
        return t('fs3combat.vehicles_disabled') if !FS3Combat.vehicles_allowed?
        return nil
      end
      
      def check_vehicle_exists
        return t('fs3combat.invalid_vehicle') if !FS3Combat.vehicle(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.vehicle(self.name), self.name, :vehicle)
        client.emit template.render
      end
    end
  end
end