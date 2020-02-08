module AresMUSH
  module Page
    class PageScanCmd
      include CommandHandler

      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end
      
      def handle
        unread = enactor.page_threads.select { |p| Page.is_thread_unread?(p, enactor) }
        if (unread.count > 0)
          client.emit_success t('page.unread_threads', :count => unread.count)
        else
          client.emit_ooc t('page.no_unread_threads')
        end
      end
    end
  end
end
