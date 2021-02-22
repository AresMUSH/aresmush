module AresMUSH
  module Page
    class PageReportCmd
      include CommandHandler

      attr_accessor :names, :reason, :start_page
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.names = list_arg(args.arg1)
        self.start_page = args.arg2
        self.reason = args.arg3
      end
      
      def required_args
        [ self.start_page, self.reason ]
      end
      
      def handle
        thread = Page.thread_for_names(self.names, enactor)
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
                
        from_page = self.start_page.to_i - 1
        
        if (from_page < 0)
          client.emit_failure t('page.invalid_report_range')
          return
        end
        
        messages = thread.sorted_messages[from_page..-1]
        Page.report_page_abuse(enactor, thread, messages, self.reason)
        client.emit_success t('page.pages_reported')
        
      end
    end
  end
end
