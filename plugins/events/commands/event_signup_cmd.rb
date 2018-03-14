module AresMUSH

  module Events
    class EventSignupCmd
      include CommandHandler
      
      attr_accessor :num, :comment
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.num = integer_arg(args.arg1)
        self.comment = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.num, self.comment ]
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
          signup = event.signups.select { |s| s.character == enactor }.first
          
          if (signup)
            signup.update(comment: self.comment)
          else
            EventSignup.create(event: event, character: enactor, comment: self.comment)
          end
          client.emit_success t('events.signed_up')
          
        end
      end
    end
  end
end
