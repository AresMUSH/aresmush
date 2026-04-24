module AresMUSH
  module Page
    class PageReviewCmd
      include CommandHandler

      attr_accessor :names, :num
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.names = list_arg(args.arg1)
        self.num = integer_arg(args.arg2)
      end
      
      def required_args
        [ self.names ]
      end
      
      def handle
        
        if (client.screen_reader)
          default_max_messages = 5
        else
          default_max_messages = 25
        end
        
        max_messages = [ self.num || default_max_messages, 100 ].min
        
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
        start_message = [ (total_messages - max_messages), 0 ].max
        list = messages[start_message, total_messages]  
                
        template = PageReviewTemplate.new(enactor, thread, list, start_message, max_messages, total_messages)
        client.emit template.render
      end
    end
  end
end
