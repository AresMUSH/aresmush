module AresMUSH
  module FS3Combat
    class CombatVehicleCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :vehicle, :passenger_type
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.vehicle = trim_arg(args.arg2)
        else
          self.name = enactor_name
          self.vehicle = titlecase_arg(cmd.args)
        end
        
        self.passenger_type = cmd.switch_is?("passenger") ? "Passenger" : "Pilot"
      end

      def required_args
        {
          args: [ self.name, self.vehicle, self.passenger_type ],
          help: 'combat'
        }
      end
      
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        combat = enactor.combat
        vehicle = FS3Combat.find_or_create_vehicle(combat, self.vehicle) 
              
        if (!vehicle)
          client.emit_failure t('fs3combat.invalid_vehicle_name')
          return
        end

        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          if (combatant.is_in_vehicle?)
            FS3Combat.leave_vehicle(combat, combatant)
          end
          FS3Combat.join_vehicle(combat, combatant, vehicle, self.passenger_type)
        end
      end
    end
  end
end