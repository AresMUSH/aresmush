module AresMUSH
  module Status
    class GoAfkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :message
      
      def crack!
        self.message = cmd.args
      end
      
      def handle      
        if (self.message == "off")
          enactor.afk_message = ""
          enactor.is_afk = false
          enactor.save
          enactor.room.emit_ooc t('status.no_longer_afk', :name => enactor.name)
          return
        end
          
        enactor.afk_message = self.message  
        enactor.is_afk = true
        if (Rooms::Api.room_type(enactor.room) == "IC")
          enactor.last_ic_location_id = enactor.room.id
        end
        enactor.save     
        enactor.room.emit_ooc t('status.go_afk', :name => enactor.name, :message => self.message)
      end
    end
  end
end
