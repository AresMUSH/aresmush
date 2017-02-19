module AresMUSH
  module FS3Combat
    class DamageTemplate < ErbTemplateRenderer


      attr_accessor :damage, :char
      
      def initialize(char)
        @char = char
        @damage = char.damage
        super File.dirname(__FILE__) + "/damage.erb"
      end      
      
      def severity(d)
        initial_sev = d.initial_severity
        current_sev = FS3Combat.display_severity(d.current_severity)
        "#{current_sev} (#{initial_sev[0..2]})"
      end
      
      def treatable(d)
        d.is_treatable? ? t('global.y') : t('global.n')
      end   
         
      def healing(d)
        total = FS3Combat.healing_points(d.current_severity)
        healed = total - d.healing_points

        return "-----" if (total == 0)

        ProgressBarFormatter.format(healed, total, 5)
      end
            
      def healed_by
        @char.healed_by.map { |h| }
      end
      
      def wound_mod
        FS3Combat.total_damage_mod(char)
      end
      
      def vehicle_notice
        combat = @char.combat
        return nil if !combat
        combatant = combat.find_combatant(@char.name)
        return nil if !combatant
        vehicle = combatant.vehicle
        vehicle ? t('fs3combat.vehicle_damage_notice', :name => vehicle.name) : nil
      end
    end
  end
end

