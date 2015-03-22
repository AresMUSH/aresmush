module AresMUSH
  module FS3Combat
    class CombatStartCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :type
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("start")
      end
      
      def crack!
        self.type = titleize_input(cmd.args)
      end
      
      def check_mock
        types = ['Mock', 'Real']
        return nil if !self.type
        return t('fs3combat.invalid_combat_type', :types => types.join(" ")) if !types.include?(self.type)
        return nil
      end
      
      def check_not_already_in_combat
        return t('fs3combat.already_in_combat') if FS3Combat.is_in_combat?(client.char.name)
        return nil
      end
      
      def handle
        combat = CombatInstance.create(:organizer => client.char, :is_real => self.type == "Real")
        combat.join(client.char.name, "observer", client.char)
        combat.save
      end
    end
  end
end