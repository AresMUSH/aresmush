module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def handle
         list = enactor.page_threads
             .to_a
             .map { |t| t.title_without_viewer(enactor) }
             .sort
         template = BorderedListTemplate.new list, t('page.page_review_index_title')
         client.emit template.render          
      end
    end
  end
end
