module AresMUSH
  module Utils
    class EchoCmd
      include CommandHandler
      
      attr_accessor :message, :to_room
      
      def parse_args
        self.message = cmd.args
        self.to_room = cmd.switch_is?("room")
      end
      
      def allow_without_login
        true
      end
      
      def required_args
        [ self.message ]
      end
      
      def handle
        if (self.to_room)
          enactor_room.clients.each do |c|
            # This uses raw emit because you're often trying to show off some formatting code to somebody.
             c.emit_raw t('echo.echo_to_room', :name => enactor_name, :message => self.message)
           end
        else
          client.emit self.message
        end
      end
      
      def log_command
        # Don't log command for privacy
      end
    end
  end
end
