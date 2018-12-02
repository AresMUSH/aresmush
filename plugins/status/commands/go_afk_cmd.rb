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
          enactor.room.emit_ooc t('status.no_longer_afk', :name => enactor.name)
          return
        end
        
        if (self.message == "on")
          self.message = nil
        end
        
        enactor.update(afk_message: self.message)
        enactor.update(is_afk: true)
        Status.update_last_ic_location(enactor)
        enactor.room.emit_ooc t('status.go_afk', :name => enactor.name, :message => self.message)
      end
    end
  end
end
