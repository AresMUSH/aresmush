module AresMUSH
  module Wiki
    class WikiPageCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : 'Home'
      end
      
      def handle
        page = WikiPage.find_one_by_name(self.name)
        if (!page)
          client.emit_failure t('wiki.page_not_found', :name => self.name)
          return
        end
        
        formatter = MarkdownFormatter.new
        template = BorderedDisplayTemplate.new formatter.to_mush(page.text), page.display_title
        
        client.emit template.render
      end      
    end
  end
end
