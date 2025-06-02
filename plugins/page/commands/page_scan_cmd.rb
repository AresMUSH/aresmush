module AresMUSH
  module Page
    class PageScanCmd
      include CommandHandler

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
