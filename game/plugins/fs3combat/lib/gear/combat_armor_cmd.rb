module AresMUSH
  module FS3Combat
    class CombatArmorCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :armor
      
      def initialize
        self.required_args = ['name', 'armor']
        self.help_topic = 'combat'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("armor")
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.armor = titleize_input(cmd.args.arg2)
        else
          self.name = client.char.name
          self.armor = titleize_input(cmd.args)
        end
      end

      def check_valid_armor
        return t('fs3combat.invalid_armor') if !FS3Combat.armor(self.armor)
        return nil
      end
      
      def handle
        FS3Combat.set_armor(client, self.name, self.armor)
      end
    end
  end
end