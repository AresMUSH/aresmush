module AresMUSH

  module Events
    class EventSignupCmd
      include CommandHandler
      
      attr_accessor :num, :comment
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.num = integer_arg(args.arg1)
        self.comment = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.num ]
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
          Events.signup_for_event(event, enactor, self.comment)
          client.emit_success t('events.signed_up')
        end
      end
    end
  end
end
