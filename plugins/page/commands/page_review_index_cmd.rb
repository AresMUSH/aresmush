module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end

      def handle
         list = enactor.page_threads
             .to_a
             .sort_by { |t| [ Page.is_thread_unread?(t, enactor) ? 1 : 0, t.last_activity ] }
             .reverse
             
         template = PageReviewIndexTemplate.new enactor, list
         client.emit template.render          
      end
    end
  end
end
