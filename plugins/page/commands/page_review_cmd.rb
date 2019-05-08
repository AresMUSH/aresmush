module AresMUSH
  module Page
    class PageReviewCmd
      include CommandHandler

      attr_accessor :names
      
      def parse_args
        self.names = cmd.args.gsub(',', ' ').split(' ')
        client.emit self.names
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
        
        template = PageLogTemplate.new(enactor, pages, chars)
        client.emit template.render
      end
    end
  end
end
