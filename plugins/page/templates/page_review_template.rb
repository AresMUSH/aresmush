module AresMUSH
  module Page
    class PageReviewTemplate < ErbTemplateRenderer
      
      attr_accessor :thread, :enactor, :paginator
      
      def initialize(enactor, thread, paginator)
        @enactor = enactor
        @thread = thread
        @paginator = paginator
        super File.dirname(__FILE__) + "/page_review.erb"
      end

      def title
        @thread.title_without_viewer(@enactor)
      end
      
      def time(page)
        OOCTime.local_long_timestr(@enactor, page.created_at)
      end
    end
  end
end