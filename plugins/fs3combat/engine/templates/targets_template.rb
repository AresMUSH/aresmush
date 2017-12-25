module AresMUSH
  module FS3Combat
    class CombatTargetsTemplate < ErbTemplateRenderer


      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/targets.erb"
      end
           
      def target(c)
        c.action ? c.action.target_names.join(', ') : '----'
      end
      
      def targeted_by(c)
        targeted = []
        c.combat.combatants.each do |opp|
          if (opp.action && opp.action.targets.include?(c))
            targeted << opp
          end
        end
        targeted.empty? ? '----' : targeted.map { |p| p.name }.join(', ')
      end
    end
  end
end