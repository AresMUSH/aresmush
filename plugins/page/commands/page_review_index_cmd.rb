module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def handle
         list = enactor.page_threads
             .to_a
             .sort_by { |t| t.title_without_viewer(enactor) }
         template = PageReviewIndexTemplate.new enactor, list
         client.emit template.render          
      end
    end
  end
end
