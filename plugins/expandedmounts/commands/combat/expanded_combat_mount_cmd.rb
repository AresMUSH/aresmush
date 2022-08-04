require 'byebug'
module AresMUSH
  module ExpandedMounts
    class ExpandedCombatMountCmd
      include CommandHandler
      # include NotAllowedWhileTurnInProgress
      
     attr_accessor :name, :mount_name, :passenger_type
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2) 
          self.name = titlecase_arg(args.arg1)
          self.mount_name = titlecase_arg(args.arg2)
        else
          self.name = enactor.name
          self.mount_name = titlecase_arg(cmd.args)
        end
        #if enactor is bonded, they're pilot. Otherwise, passenger.


        passenger = Character.named(self.name)
        mount = Mount.named(self.mount_name)
        return "That's not a mount" if !mount
        if passenger == mount.bonded 
          self.passenger_type = "Pilot" 
        else
          self.passenger_type = "Passenger"
        end
  
      end

      # def required_args
      #   [ self.name, self.mount_name, self.passenger_type ]
      # end
      
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def check_valid_mount
        # Check to see if the mount exists
        # Check to be sure the mount isn't full.
        return nil
      end
      
      def handle
        combat = enactor.combat

        # Allow joining someone who's already in a vehicle by name.  It's not
        # actually the vehicle name, it's their name.
        combatant = combat.find_combatant(self.mount_name)
        if (combatant && combatant.vehicle)
          self.mount_name = combatant.vehicle.name
        end
        
        # self.names.each do |name|
        
          vehicle = ExpandedMounts.find_or_create_vehicle(combat, self.mount_name) 

          
          if (!vehicle)
            client.emit_failure t('expandedmounts.invalid_vehicle_name')
            # Replace with my own message
            return
          end
        
          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|
            # Probably okay to leave in for future people who may use the plugin?
            if (combatant.mount_type)
              client.emit_failure t('fs3combat.cant_be_in_both_vehicle_and_mount', :name => combatant.name)
              return
            end
            
            if (combatant.is_in_vehicle?)
              ExpandedMounts.leave_vehicle(combat, combatant)
            end
            Mount.named(self.mount_name).update(vehicle: vehicle)
            combatant.update(mount_name: mount_name)
            ExpandedMounts.join_vehicle(combat, combatant, vehicle, self.passenger_type)
          # end
        end
      end
    end
  end
end