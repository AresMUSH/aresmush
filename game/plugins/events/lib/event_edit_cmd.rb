module AresMUSH

  module Events
    class EventEditCmd
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
          if (Events.can_manage_events?(enactor) || enactor == event.character)
            start_time = OOCTime.format_date_time_for_entry(event.starts)
            grab_text = "#{event.title}/#{start_time}/#{event.description}"
            Utils.grab client, enactor, "event/update #{self.num}=#{grab_text}"
          else
            client.emit_failure t('dispatcher.not_allowed')
          end 
        end
      end
    end
  end
end
