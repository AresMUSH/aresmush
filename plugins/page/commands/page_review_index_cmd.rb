module AresMUSH
  module Page
    class PageReviewIndexCmd
      include CommandHandler

      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end

      def handle
         list = enactor.sorted_page_threads

         Login.mark_notices_read(enactor, :pm)
             
         template = PageReviewIndexTemplate.new enactor, list
         client.emit template.render          
      end
    end
  end
end
