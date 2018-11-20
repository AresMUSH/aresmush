module AresMUSH
  module FS3Combat
    class CombatTypeCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      # combat/type <type>

      attr_accessor :combatant_type

      def parse_args
        self.combatant_type = titlecase_arg(cmd.args)
      end


      def check_type
        return nil if !self.combatant_type
        return t('fs3combat.invalid_combatant_type') if !FS3Combat.combatant_types.include?(self.combatant_type)
        return t('fs3combat.use_vehicle_type_cmd') if FS3Combat.passenger_types.include?(self.combatant_type)
        return nil
      end

      def handle
        enactor.combatant.update(combatant_type: self.combatant_type)
        FS3Combat.emit_to_combat enactor.combat, t('fs3combat.changed_type', :name => enactor.name, :type => combatant_type)
      end

    end
  end
end
