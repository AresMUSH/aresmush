module AresMUSH
  module Idle
    class IdleQueueTemplate < ErbTemplateRenderer

      include TemplateFormatters
      
      attr_accessor :queue
      
      def initialize(list, client)
        @queue = []
        list.each do |k, v|
          @queue << { char: Character.find(k), action: v }
        end

        @client = client
        super File.dirname(__FILE__) + "/idle_queue.erb"
      end
      
      def name(entry)
        char = entry[:char]
        char.name
      end
      
      def lastwill(entry)
        char = entry[:char]
        char.lastwill
      end
      
      def last_on(entry)
        char = entry[:char]
        OOCTime::Api.local_short_timestr(@client, Login::Api.last_on(char))
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