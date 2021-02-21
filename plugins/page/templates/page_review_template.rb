module AresMUSH
  module Page
    class PageReviewTemplate < ErbTemplateRenderer
      
      attr_accessor :thread, :enactor, :messages, :starting_index
      
      def initialize(enactor, thread, messages, starting_index)
        @enactor = enactor
        @thread = thread
        @messages = messages
        @starting_index = starting_index
        super File.dirname(__FILE__) + "/page_review.erb"
      end

      def title
        @thread.title_customized(@enactor)
      end
      
      def time(page)
        OOCTime.local_long_timestr(@enactor, page.created_at)
      end
    end
  end
end