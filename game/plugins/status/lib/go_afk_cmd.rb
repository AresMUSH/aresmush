module AresMUSH
  module Status
    class GoAfkCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("afk")
      end
      
      def crack!
        self.message = cmd.args
      end
      
      def check_can_set_status
        return t('status.newbies_cant_change_status') if !client.char.is_approved?
        return nil
      end
      
      def handle        
        char = client.char
        char.room.emit_ooc t('status.go_afk', :name => char.name, :message => self.message)
        char.afk_message = self.message  
        # No need to double save; status set will do it.
        Status.set_status(char, "AFK")        
      end
    end
  end
end
