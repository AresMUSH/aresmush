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

      def format_mount(mount)
        "#{mount.name} (#{mount.expanded_mount_type})" 
      end
      
      def rider(m)
        m.rider ? m.rider.name : "---"
      end
      
      def passengers(m)
        m.passengers.map { |p| p.name }.join(', ')
      end
    end
  end
end