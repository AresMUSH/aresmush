module AresMUSH
  module Idle
    class IdleQueueTemplate < ErbTemplateRenderer

      
      attr_accessor :queue
      
      def initialize(list, enactor)
        @queue = []
        list.each do |k, v|
          @queue << { char: Character[k], action: v }
        end

        @enactor = enactor
        super File.dirname(__FILE__) + "/idle_queue.erb"
      end
      
      def name(entry)
        char = entry[:char]
        char.name
      end
      
      def sorted_queue
      	 @queue.sort_by { |q| last_on(q) }
      end
            
      def lastwill(entry)
        char = entry[:char]
        char.idle_lastwill
      end
      
      def last_on(entry)
        char = entry[:char]
        OOCTime::Api.local_short_timestr(@enactor, char.last_on)
      end
      
      def action(entry)
      	case entry[:action]
           when "Destroy"
             color = "%xh%xx"
           when "Warn"
             color = "%xh"
           when "Npc"
             color = "%xb"
           when "Gone"
             color = "%xh%xy"
           when "Roster"
             color = "%xh%xg"
	         else
	           color = "%xc"
         end
      	"#{color}#{entry[:action]}%xn"
      end
            
      def action(entry)
        entry[:action]
      end
      
      def highlight_color(entry)
        char = entry[:char]
        char.is_approved? ? "%xh%xg" : ""
      end
      
      
    end
  end
end