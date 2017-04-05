module AresMUSH

  module Events
    class EventCreateCmd
      include CommandHandler
      
      attr_accessor :title, :date_time_desc

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.title = titlecase_arg(args.arg1)
        self.date_time_desc = trim_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.title, self.date_time_desc ],
          help: 'events'
        }
      end
      
      def handle
        date, time, desc, error = Events.parse_date_time_desc(self.date_time_desc)
        
        if (error)
          client.emit_failure error
          return
        end
        
        Event.create(title: self.title, 
          time: time, 
          description: desc,
          date: date, 
          character: enactor)
          
        client.emit_success t('events.event_created')
      end
    end
  end
end
