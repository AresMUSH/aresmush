module AresMUSH
  module Idle
    class IdleQueueTemplate < ErbTemplateRenderer

      include TemplateFormatters
      
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
      
      def lastwill(entry)
        char = entry[:char]
        char.idle_lastwill
      end
      
      def last_on(entry)
        char = entry[:char]
        OOCTime::Api.local_short_timestr(@enactor, char.last_on)
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