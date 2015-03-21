module AresMUSH
  module FS3Combat
    class CombatStartCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :type
      
      def initialize
        FS3Combat.combats = []
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("start")
      end
      
      def crack!
        self.type = titleize_input(cmd.args)
      end
      
      def check_not_already_in_combat
        return t('fs3combat.already_in_combat') if FS3Combat.is_in_combat?(client.char.name)
        return nil
      end
      
      def handle
        FS3Combat.combats << {}
        index = FS3Combat.combats.length - 1
        FS3Combat.add_to_combat(client, client.char, index, "organizer")
      end
    end
  end
end