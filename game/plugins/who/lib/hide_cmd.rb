module AresMUSH
  module Who
    class HideCmd
      include AresMUSH::Plugin

      # Validators
      dont_allow_switches_or_args
      must_be_logged_in
      
      def want_command?(client, cmd)
         cmd.root_is?("hide")
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
