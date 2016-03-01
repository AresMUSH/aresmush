module AresMUSH
  module Who
    class HideCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include CommandWithoutSwitches
      
      def want_command?(client, cmd)
         cmd.root_is?("hide") || cmd.root_is?("unhide")
      end
      
      def handle
        if cmd.root_is?("unhide")
          client.emit_success(t('who.hide_disabled'))
          client.char.hidden = false
        else
          client.emit_success(t('who.hide_enabled'))
          client.char.hidden = true
        end            
      end      
    end
  end
end
