module AresMUSH
  module Page
    class PageReviewCmd
      include CommandHandler

      attr_accessor :names
      
      def parse_args
        self.names = list_arg(cmd.args)
        client.emit self.names
      end
      
      def handle
        thread = Page.thread_for_names(self.names.concat([enactor_name]).uniq)
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
        
        Page.mark_thread_read(thread, enactor)
        template = PageReviewTemplate.new(enactor, thread, thread.sorted_messages)
        client.emit template.render
      end
    end
  end
end
