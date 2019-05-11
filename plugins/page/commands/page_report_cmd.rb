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
        thread = Page.thread_for_names(self.names.concat(enactor_name).uniq)
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
        
        template = PageReviewTemplate.new(enactor, thread, thread.sorted_messages[from_page..to_page], chars)
        log = template.render
        
        body = t('page.page_reported_body', :name => chars.map { |c| c.name }.join, :reporter => enactor_name)
        body << self.reason
        body << "%R"
        body << log
        Jobs.create_job(Jobs.trouble_category, t('page.page_reported_title'), body, Game.master.system_character)
        
      end
    end
  end
end
