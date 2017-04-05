module AresMUSH

  module Events
    class EventEditCmd
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
          if (Events.can_manage_events?(enactor) || enactor == event.character)
            grab_text = "#{event.title}/#{event.date.month}/#{event.date.day}/#{event.date.year}/#{event.time}/#{event.description}"
            Utils::Api.grab client, enactor, "event/update #{self.num}=#{grab_text}"
          else
            client.emit_failure t('dispatcher.not_allowed')
          end 
        end
      end
    end
  end
end
