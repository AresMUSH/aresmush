module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :num, :combatant_type
      
      def initialize
        self.required_args = ['names', 'num']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("join")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_optional_arg3)
          self.names = cmd.args.arg1 ? cmd.args.arg1.split(" ").map { |n| titleize_input(n) } : nil
          self.num = trim_input(cmd.args.arg2)
          self.combatant_type = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_slash_optional_arg2)
          self.names = [ client.name ]
          self.num = titleize_input(cmd.args.arg1)
          self.combatant_type = titleize_input(cmd.args.arg2)
        end
      end

      def check_commas
        return t('fs3combat.dont_use_commas_for_join') if self.names.any? { |n| n.include?(",")}
        return nil
      end
      
      def check_type
        valid_types = FS3Combat.combatant_types 
        vehicle_types = [ "Pilot", "Passenger" ]
        return nil if !self.combatant_type       
        return t('fs3combat.invalid_combatant_type') if !valid_types.include?(self.combatant_type)
        return t('fs3combat.use_vehicle_type_cmd') if vehicle_types.include?(self.combatant_type)
        return nil
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        self.names.each_with_index do |n, i|
          Global.dispatcher.queue_timer(i, "Add to Combat") do
            add_to_combat(combat, n)
          end
        end
      end
      
      def add_to_combat(combat, name)
        if FS3Combat.is_in_combat?(name)
          client.emit_failure t('fs3combat.already_in_combat', :name => name) 
          return
        end
        
        result = ClassTargetFinder.find(name, Character, client)
        
        type = self.combatant_type || Global.read_config("fs3combat", "default_type")
        combatant = combat.join(name, type, result.target)
        combat.save
        
        FS3Combat.set_default_gear(client, combatant, type)
      end
    end
  end
end