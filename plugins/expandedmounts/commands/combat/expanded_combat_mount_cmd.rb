require 'byebug'
module AresMUSH
  module ExpandedMounts
    class ExpandedCombatMountCmd
      include CommandHandler
      # include NotAllowedWhileTurnInProgress

     attr_accessor :name, :mount_name, :passenger_type, :mount, :passenger

      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.mount_name = titlecase_arg(args.arg2)
        else
          self.name = enactor.name
          self.mount_name = titlecase_arg(cmd.args)
        end
        #if enactor is bonded, they're rider. Otherwise, passenger.

        self.passenger = Character.named(self.name)
        self.mount = Mount.named(self.mount_name)

      end

      # def required_args
      #   [ self.name, self.mount_name, self.passenger_type ]
      # end

      def check_errors
        return t('expandedmounts.invalid_mount_name') if !self.mount
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return t('expandedmounts.rider_not_in_combat', :rider => self.mount.bonded.name, :mount => self.mount.name  ) if !self.mount.bonded.is_in_combat?
        return t('expandedmounts.already_on_mount', :mount => self.mount.name) if enactor.combatant.mount == self.mount
        return nil
      end



      def handle
        combat = enactor.combat

        if self.passenger == self.mount.bonded
          self.passenger_type = "Rider"
        # else
        #   self.passenger_type = "Passenger"
        end

        # Allow joining someone who's already in a vehicle by name.  It's not
        # actually the vehicle name, it's their name.
        # combatant = combat.find_combatant(self.mount.name)
        # if (combatant && combatant.mount)
        #   self.mount_name = combatant.mount.name
        # end

        # self.names.each do |name|


          FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|
            # Probably okay to leave in for future people who may use the plugin?
            if (combatant.vehicle)
              client.emit_failure t('fs3combat.cant_be_in_both_vehicle_and_mount', :name => combatant.name)
              return
            end

            if (combatant.is_on_mount?)
              ExpandedMounts.leave_mount(combatant)
            end
            ExpandedMounts.join_mount(combat, combatant, mount, self.passenger_type)
          # end
        end
      end
    end
  end
end