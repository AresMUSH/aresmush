module AresMUSH
  module Page
    class PageReviewCmd
      include CommandHandler

      attr_accessor :names
      
      def parse_args
        self.names = list_arg(cmd.args)
      end
      
      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end
      
      def handle
        if (self.names.count == 1 && self.names[0].to_i > 0)
          list = enactor.sorted_page_threads
          thread = list[self.names[0].to_i - 1]
        else
          thread = Page.thread_for_names(self.names, enactor)
        end
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
        
        Page.mark_thread_read(thread, enactor)
        Login.mark_notices_read(enactor, :pm, thread.id)
      
        messages = thread.sorted_messages
        total_messages = messages.count
        start_message = [ (total_messages - 50), 0 ].max
        list = messages[start_message, total_messages]  
                
        template = PageReviewTemplate.new(enactor, thread, list, start_message)
        client.emit template.render
      end
    end
  end
end
