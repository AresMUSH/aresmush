module AresMUSH
  module Page
    class PageReportCmd
      include CommandHandler

      attr_accessor :names, :reason, :range
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.names = list_arg(args.arg1)
        self.range = args.arg2
        self.reason = args.arg3
      end
      
      def required_args
        [ self.range, self.reason ]
      end
      
      def handle
        self.names << enactor_name
        thread = Page.thread_for_names(self.names.uniq)
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
                
        from_page = self.range.before("-").to_i - 1
        to_page = self.range.after("-").to_i - 1
        
        if (from_page < 0 || to_page < 0 || to_page < from_page)
          client.emit_failure t('page.invalid_report_range')
          return
        end
        
        messages = thread.sorted_messages[from_page..to_page]
        Page.report_page_abuse(enactor, thread, messages, self.reason)
        client.emit_success t('page.pages_reported')
        
      end
    end
  end
end
