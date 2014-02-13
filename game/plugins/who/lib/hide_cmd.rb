module AresMUSH
  module Who
    class HideCmd
      include AresMUSH::Plugin

      def want_command?(cmd)
         cmd.logged_in? && cmd.root_is?("hide")
      end
      
      def validate
        return t('who.invalid_hide_syntax') if !@cmd.root_only?
        nil
      end
      
      def handle
        if (client.char.hidden)
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
