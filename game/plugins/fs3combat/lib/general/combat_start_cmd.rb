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
        self.type = cmd.args ? titleize_input(cmd.args) : "Real"
      end
      
      # TODO - Mock not implemented
      #def check_mock
      #  types = ['Mock', 'Real']
      #  return nil if !self.type
      #  return t('fs3combat.invalid_combat_type', :types => types.join(" ")) if !types.include?(self.type)
      #  return nil
      #end
      
      def check_mock
        return "Sorry, mock is not implemented yet" if self.type != "Real"
        return nil
      end
        
      def check_not_already_in_combat
        return t('fs3combat.already_in_combat', :name => client.char.name) if client.char.is_in_combat?
        return nil
      end
      
      def handle
        is_real = self.type == "Real"
        combat = CombatInstance.create(:organizer => client.char, :is_real => is_real)
        combat.join(client.char.name, "observer", client.char)
        combat.save
        
        client.emit_ooc is_real ? t('fs3combat.start_real_combat') : t('fs3combat.start_mock_combat')
      end
    end
  end
end