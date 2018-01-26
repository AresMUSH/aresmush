module AresMUSH
  module Who
    class HideCmd
      include CommandHandler
      
      def handle
        if cmd.root_is?("unhide")
          client.emit_success(t('who.hide_disabled'))
          enactor.update(who_hidden: false)
        else
          client.emit_success(t('who.hide_enabled'))
          enactor.update(who_hidden: true)
        end            
      end      
    end
  end
end
