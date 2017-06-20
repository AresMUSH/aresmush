module AresMUSH
  module FS3Combat
    class DamageTemplate < ErbTemplateRenderer


      attr_accessor :damage, :target
      
      def initialize(target)
        @target = target
        @damage = target.damage
        super File.dirname(__FILE__) + "/damage.erb"
      end      
      
      def severity(d)
        initial_sev = d.initial_severity
        current_sev = FS3Combat.display_severity(d.current_severity)
        "#{current_sev} (#{initial_sev[0..2]})"
      end
      
      def treatable(d)
        d.is_treatable? ? t('global.y') : '-'
      end   
         
      def healing(d)
        total = FS3Combat.healing_points(d.current_severity)
        healed = total - d.healing_points

        return "-----" if (total == 0)

        ProgressBarFormatter.format(healed, total, 5)
      end
            
      def healed_by
        return t('global.none') if @target.class != AresMUSH::Character
        docs = @target.doctors.map { |h| h.name }
        docs.count > 0 ? docs.join(", ") : t('global.none')
      end
      
      def wound_mod
        FS3Combat.total_damage_mod(target)
      end
      
      def vehicle_notice
        combat = @target.combat
        return nil if !combat
        combatant = combat.find_combatant(@target.name)
        return nil if !combatant
        vehicle = combatant.vehicle
        vehicle ? t('fs3combat.vehicle_damage_notice', :name => vehicle.name) : nil
      end
    end
  end
end

