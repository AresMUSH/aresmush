module AresMUSH
  module Login
    class ReserveCmd
      include CommandHandler
      
      attr_accessor :charname
      
      def parse_args
        self.charname = cmd.args ? titlecase_arg(cmd.args.before(" ")) : nil
      end
      
      def check_name
        return t('dispatcher.invalid_syntax', :cmd => 'create') if !charname
        return Character.check_name(charname)
      end
      
      def check_can_reserve
        return t('dispatcher.not_allowed')  if !Login.can_manage_login?(enactor)
        return nil
      end
      
      def check_name_taken
        return Login.name_taken?(self.charname)
      end
      
      def handle
        char = Character.create(name: charname, room: Game.master.welcome_room)
        temp_password = Login.set_random_password(char)
        
        client.emit_success(t('login.char_reserved', :name => charname, :password => temp_password))
        Global.dispatcher.queue_event CharCreatedEvent.new(nil, char.id)
      end
    end
  end
end
