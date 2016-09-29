module AresMUSH
  module FS3Combat
    class CombatVehicleCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :vehicle, :passenger_type
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name', 'vehicle', 'passenger_type']
        self.help_topic = 'combat'
        super
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.vehicle = trim_input(cmd.args.arg2)
        else
          self.name = enactor_name
          self.vehicle = titleize_input(cmd.args)
        end
        
        self.passenger_type = cmd.switch_is?("passenger") ? "Passenger" : "Pilot"
      end
      
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        combat = enactor.combatant.combat
        vehicle = combat.find_or_create_vehicle(self.vehicle) 
              
        if (!vehicle)
          client.emit_failure t('fs3combat.invalid_vehicle_name')
          return
        end

        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          if (combatant.is_in_vehicle?)
            combat.leave_vehicle(combatant)
          end
          combat.join_vehicle(combatant, vehicle, self.passenger_type)
        end
        
        combat.save
      end
    end
  end
end