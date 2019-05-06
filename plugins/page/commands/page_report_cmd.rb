module AresMUSH
  module Page
    class PageReportCmd
      include CommandHandler

      attr_accessor :names, :reason, :range
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.names = args.arg1 ? args.arg1.gsub(',', ' ').split(' ') : []
        self.range = args.arg2
        self.reason = args.arg3
      end
      
      def required_args
        [ self.range, self.reason ]
      end
      
      def handle
        chars = []
        self.names.each do |name|
          char = Character.named(name)
          if (!char)
            client.emit_failure t('page.invalid_recipient', :name => name)
            return
          end
          chars << char
        end
        
        thread = Page.generate_thread_name([enactor].concat(chars))
        pages = enactor.page_messages.select { |p| p.thread_name == thread }.sort_by { |p| p.created_at }
        
        from_page = self.range.before("-").to_i - 1
        to_page = self.range.after("-").to_i - 1
        
        if (from_page < 0 || to_page < 0 || to_page < from_page)
          client.emit_failure t('page.invalid_report_range')
          return
        end
        
        template = PageLogTemplate.new(enactor, pages[from_page..to_page], chars)
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
