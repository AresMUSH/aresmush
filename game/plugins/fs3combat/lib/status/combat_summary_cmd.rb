module AresMUSH
  module FS3Combat
    class CombatSummaryCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("summary")
      end
      
      def handle
        combat = FS3Combat.combat(client.char.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        if (combat.organizer != client.char)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end
        
        template = CombatSummaryTemplate.new(combat, @client)
        template.render
      end
    
    end
  end
end