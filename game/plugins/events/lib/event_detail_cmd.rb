module AresMUSH

  module Events
    class EventDetailCmd
      include CommandHandler
      
      attr_accessor :num

      def crack!
        self.num = cmd.args ? cmd.args.to_i : nil
      end
      
      def required_args
        {
          args: [ self.num ],
          help: 'events'
        }
      end
      def handle
        events = Events.upcoming_events(30)
        if (self.num < 0 || self.num > events.count)
          client.emit_failure t('events.invalid_event')
          return
        end
        
        template = EventDetailTemplate.new(events[self.num - 1], enactor)
        client.emit template.render
      end
    end
  end
end
