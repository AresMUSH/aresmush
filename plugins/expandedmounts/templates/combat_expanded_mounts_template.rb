module AresMUSH
  module ExpandedMounts
    class CombatExpandedMountsTemplate < ErbTemplateRenderer


      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/combat_expanded_mounts.erb"
      end
           
      def mounts
        combat.mounts.sort_by(:name, :order => "ALPHA" )
      end

      def format_damage(c)
        return "%xh%xr#{t('fs3combat.ko_status')}%xn" if c.is_ko
        FS3Combat.print_damage(c.total_damage_mod)
      end

      def format_mount(mount)
        "#{mount.name} (#{mount.expanded_mount_type})" 
      end
      
      def rider(m)
        m.rider ? "#{m.rider.name} (mnt)" : m.bonded.name 
      end
      
      def passengers(m)
        m.passengers.map { |p| p.name }.join(', ')
      end
    end
  end
end