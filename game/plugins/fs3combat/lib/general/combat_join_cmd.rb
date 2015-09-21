module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :num
      
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
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          if cmd.args.arg1
            if (cmd.args.arg1 =~ /,/)
              split_char = ","
            else
              split_char = " "
            end
            self.names = cmd.args.arg1.split(split_char).map { |n| titleize_input(n) }
          end
          self.num = trim_input(cmd.args.arg2)
        else
          self.names = [ client.name ]
          self.num = titleize_input(cmd.args)
        end
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
        
        type = Global.read_config("fs3combat", "default_type")
        combatant = combat.join(name, type, result.target)
        combat.save
        
        FS3Combat.set_default_gear(client, combatant, type)
      end
    end
  end
end