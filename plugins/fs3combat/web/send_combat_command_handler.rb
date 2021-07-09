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
        sender_name = request.args[:sender]
        command_text = request.args[:command]
        enactor = request.enactor
                
        error = Website.check_login(request)
        return error if error
        
        sender = sender_name.blank? ? enactor : Character.named(sender_name)
        combat = Combat[combat_id]
        if (!combat || !sender)
          return { error: t('webportal.not_found') }
        end
        
        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (sender.combat != combat)
           return { error: t('fs3combat.you_are_not_in_combat') }
        end
        
        cmd = Command.new(command_text)
        
        client = DummyClient.new
        handler_class = FS3Combat.get_cmd_handler(client, cmd, sender)
        handler = handler_class.new(client, cmd, sender)
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


