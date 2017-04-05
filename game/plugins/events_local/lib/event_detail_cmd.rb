module AresMUSH

  module Events
    class EventDetailCmd
      include CommandHandler
      
      attr_accessor :num

      def parse_args
        self.num = integer_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.num ],
          help: 'events'
        }
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event|     
          template = EventDetailTemplate.new(event, enactor)
          client.emit template.render
        end
      end
    end
  end
end
