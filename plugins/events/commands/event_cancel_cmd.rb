module AresMUSH

  module Events
    class EventCancelCmd
      include CommandHandler
      
      attr_accessor :num
      
      def parse_args
        self.num = integer_arg(cmd.args)
      end
      
      def required_args
        [ self.num ]
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
          signup = event.signups.select { |s| s.character == enactor }.first
          if (!signup)
            client.emit_failure t('events.not_signed_up')
            return
          end
          
          signup.delete
          client.emit_success t('events.signup_cancelled')
          
        end
      end
    end
  end
end
