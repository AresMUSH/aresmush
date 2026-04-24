module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def handle
         list = enactor.sorted_page_threads

         Login.mark_notices_read(enactor, :pm)
             
         template = PageReviewIndexTemplate.new enactor, list
         client.emit template.render          
      end
    end
  end
end
