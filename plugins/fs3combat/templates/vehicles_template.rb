module AresMUSH
  module FS3Combat
    class CombatVehiclesTemplate < ErbTemplateRenderer


      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/vehicles.erb"
      end
           
      def vehicles
        combat.vehicles.sort_by(:name, :order => "ALPHA" )
      end
      
      def pilot(v)
        v.pilot ? v.pilot.name : "---"
      end
      
      def passengers(v)
        v.passengers.map { |p| p.name }.join(', ')
      end
    end
  end
end