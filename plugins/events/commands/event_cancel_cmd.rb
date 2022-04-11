module AresMUSH

  module Events
    class EventCancelCmd
      include CommandHandler
      
      attr_accessor :num, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.num = integer_arg(args.arg1)
        self.name = args.arg2 ? titlecase_arg(args.arg2) : enactor_name
      end
      
      def required_args
        [ self.num, self.name ]
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
          
          char = Character.named(self.name)
          if (!char)
            client.emit_failure t('dispatcher.not_found')
            return
          end
          
          error = Events.cancel_signup(event, char, enactor)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('events.signup_cancelled', :name => self.name)
          end
        end
      end
    end
  end
end
