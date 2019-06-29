module AresMUSH
  module Page
    class PageReviewCmd
      include CommandHandler

      attr_accessor :names
      
      def parse_args
        self.names = list_arg(cmd.args)
      end
      
      def handle
        thread = Page.thread_for_names(self.names.concat([enactor_name]).uniq)
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
        
        Page.mark_thread_read(thread, enactor)
        
        paginator = Paginator.paginate(thread.sorted_messages.reverse, cmd.page, 25)
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
          return
        end
        
        template = PageReviewTemplate.new(enactor, thread, paginator)
        client.emit template.render
      end
    end
  end
end
