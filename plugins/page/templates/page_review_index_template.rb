module AresMUSH
  module Page
    class PageReviewIndexTemplate < ErbTemplateRenderer
      
      attr_accessor :threads, :enactor
      
      def initialize(enactor, threads)
        @enactor = enactor
        @threads = threads
        super File.dirname(__FILE__) + "/page_review_index.erb"
      end

      def title(thread)
        thread.title_customized(@enactor)
      end
      
      def unread_marker(thread)
        Page.is_thread_unread?(thread, @enactor) ? "(U)" : "   "
      end
    end
  end
end