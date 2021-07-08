module AresMUSH
  module FS3Combat
    class DummyClient
      attr_accessor :success, :message
      
      def emit_success(message)
        self.success = true
        self.message = message
      end
      
      def emit_failure(message)
        self.success = false
        self.message = message
      end
      
      def logged_in?
        true
      end
    end
  
    class SendCombatCommandRequestHandler
      def handle(request)
        combat_id = request.args[:combat_id]
        combatant_id = request.args[:combatant_id]
        command_text = request.args[:command]
        enactor = request.enactor

        error = Website.check_login(request)
        return error if error
        
        combat = Combat[combat_id]
        combatant = Combatant[combatant_id]
        if (!combat || !combatant)
          return { error: t('webportal.not_found') }
        end

        if (combatant.combat != combat)
           return { error: t('fs3combat.you_are_not_in_combat') }
        end
        
        cmd = Command.new(command_text)
        
        client = DummyClient.new
        handler_class = FS3Combat.get_cmd_handler(client, cmd, enactor)
        handler = handler_class.new(client, cmd, enactor)
        handler.on_command
         
        { 
          success: client.success,
          message: client.message,
          data: FS3Combat.build_combat_web_data(combat, enactor)
        }
       
      end
    end
  end
end


