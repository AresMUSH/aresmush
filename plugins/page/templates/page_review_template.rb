module AresMUSH
  module Page
    class PageReviewTemplate < ErbTemplateRenderer
      
      attr_accessor :thread, :enactor, :messages, :starting_index, :max_messages, :total_messages
      
      def initialize(enactor, thread, messages, starting_index, max_messages, total_messages)
        @enactor = enactor
        @thread = thread
        @messages = messages
        @starting_index = starting_index
        @max_messages = max_messages
        @total_messages = total_messages
        
        super File.dirname(__FILE__) + "/page_review.erb"
      end

      def title
        @thread.title_customized(@enactor)
      end
      
      def time(page)
        OOCTime.local_long_timestr(@enactor, page.created_at)
      end
      
      def more_messages
        if (total_messages > max_messages)
          return t('page.more_on_portal', :num => max_messages, :total => total_messages)
        else
          return nil
        end
      end
      
    end
  end
end