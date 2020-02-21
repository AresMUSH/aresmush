module AresMUSH
  module Page
    class PageNewCmd
      include CommandHandler

      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end
      
      def handle
        thread = enactor.page_threads.select { |p| Page.is_thread_unread?(p, enactor) }.first
        if (thread)
          Page.mark_thread_read(thread, enactor)
          Login.mark_notices_read(enactor, :pm, thread.id)
      
          messages = thread.sorted_messages
          total_messages = messages.count
          start_message = [ (total_messages - 50), 0 ].max
          list = messages[start_message, total_messages]  
                
          template = PageReviewTemplate.new(enactor, thread, list, start_message)
          client.emit template.render
        else
          client.emit_ooc t('page.no_unread_threads')
        end
      end
    end
  end
end
