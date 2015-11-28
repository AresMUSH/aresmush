module AresMUSH
  module FS3Combat
    class CombatHudCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch.nil?
      end
      
      def handle
        combat = FS3Combat.combat(client.char.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        template = CombatHudTemplate.new(combat, @client)
        template.render
      end
    end
  end
end