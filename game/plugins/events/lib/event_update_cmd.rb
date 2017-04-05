module AresMUSH

  module Events
    class EventUpdateCmd
      include CommandHandler
      
      attr_accessor :num, :title, :date_time_desc

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.num = integer_arg(args.arg1)
        self.title = titlecase_arg(args.arg2)
        self.date_time_desc = trim_arg(args.arg3)
      end
      
      def required_args
        {
          args: [ self.num, self.title, self.date_time_desc ],
          help: 'events'
        }
      end
      
      def handle
        Events.with_an_event(self.num, client, enactor) do |event| 
           if (Events.can_manage_events?(enactor) || enactor == event.character)
             date, time, desc, error = Events.parse_date_time_desc(self.date_time_desc)
        
             if (error)
               client.emit_failure error
               return
             end
          
             event.update(title: self.title)
             event.update(time: time)
             event.update(description: desc)
             event.update(date: date)
             
             client.emit_success t('events.event_updated')
           else
             client.emit_failure t('dispatcher.not_allowed')
           end 
        end
      end
    end
  end
end
