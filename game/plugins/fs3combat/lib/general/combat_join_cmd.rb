module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :type, :num
      
      def initialize
        self.required_args = ['name', 'type', 'num']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("join")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
          self.name = titleize_input(cmd.args.arg1)
          self.num = trim_input(cmd.args.arg2)
          self.type = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_slash_arg2)
          self.name = client.name
          self.num = titleize_input(cmd.args.arg1)
          self.type = titleize_input(cmd.args.arg2)
        end
      end
      
      def check_type
        return t('fs3combat.invalid_combatant_type') if !FS3Combat.combatant_types.keys.include?(self.type)
        return nil
      end
      
      def check_not_already_in_combat
        return t('fs3combat.already_in_combat', :name => self.name) if FS3Combat.is_in_combat?(self.name)
        return nil
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        result = ClassTargetFinder.find(self.name, Character, client)
        
        combat.join(self.name, self.type, result.target)
        combat.save
      end
    end
  end
end