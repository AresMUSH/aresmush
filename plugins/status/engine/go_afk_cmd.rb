module AresMUSH
  module Status
    class GoAfkCmd
      include CommandHandler
      
      attr_accessor :message
      
      def parse_args
        self.message = cmd.args
      end
      
      def handle      
        if (self.message == "off")
          enactor.update(afk_message: "")
          enactor.update(is_afk: false)
          Rooms.emit_ooc_to_room(enactor.room, t('status.no_longer_afk', :name => enactor.name))
          return
        end
          
        enactor.update(afk_message: self.message)
        enactor.update(is_afk: true)
        if (enactor.room.room_type == "IC")
          enactor.update(last_ic_location: enactor.room)
        end
        Rooms.emit_ooc_to_room(enactor.room, t('status.go_afk', :name => enactor.name, :message => self.message))
      end
    end
  end
end
