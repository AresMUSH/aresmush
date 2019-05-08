module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def handle
         list = enactor.page_messages
             .to_a
             .group_by { |p| p.thread_name }
             .map { |name, group_pages | Page.thread_title(name, enactor) }
             .sort
         template = BorderedListTemplate.new list, t('page.page_review_index_title')
         client.emit template.render          
      end
    end
  end
end
