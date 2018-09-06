module AresMUSH
  module FS3Combat
    class CombatHitlocsCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor.name
      end

      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        
        combat = enactor.combat
        vehicle = combat.find_vehicle_by_name(self.name)
        if (vehicle)
          client.emit_failure t('fs3combat.use_pilot_name_for_vehicle_hitlocs')
          return
        end
        
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          hitlocs = FS3Combat.hitloc_areas(combatant).keys
          
          footer = combatant.is_in_vehicle? ? "%R%xh#{t('fs3combat.hitlocs_vehicle_warning', :name => self.name)}%xn" : nil
          template = BorderedListTemplate.new hitlocs.sort, t('fs3combat.hitlocs_for', :name => self.name), footer
          client.emit template.render
        end
      end
    end
  end
end