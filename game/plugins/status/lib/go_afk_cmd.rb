module AresMUSH
  module Status
    class GoAfkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :message
      
      def want_command?(client, cmd)
        cmd.root_is?("afk")
      end
      
      def crack!
        self.message = cmd.args
      end
      
      def handle      
        char = client.char

        if (self.message == "off")
          char.afk_message = ""
          char.is_afk = false
          char.save
          char.room.emit_ooc t('status.no_longer_afk', :name => char.name)
          return
        end
          
        char.afk_message = self.message  
        char.is_afk = true
        if (char.room.room_type == "IC")
          char.last_ic_location_id = char.room.id
        end
        char.save     
        char.room.emit_ooc t('status.go_afk', :name => char.name, :message => self.message)
      end
    end
  end
end
