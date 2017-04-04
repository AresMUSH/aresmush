module AresMUSH
  module Help
    class HelpListCmd
      include CommandHandler

      attr_accessor :category
      
      def parse_args
        self.category = Help.command_to_category(cmd.root)
      end
      
      def allow_without_login
        true
      end
      
      def check_valid_category
        return t('help.unrecognized_help_library') if !self.category
        return nil
      end
        
      def check_can_view_help
        return nil if !self.category
        return t('dispatcher.not_allowed') if !Help.can_access_help?(enactor, self.category)
        return nil
      end
      
      def handle        
        list = Help.toc(self.category)
        topics_per_page = Help.category_config[self.category]['topics_per_page']
        paginator = Paginator.paginate(list, cmd.page, topics_per_page)
        
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
        else
          template = HelpListTemplate.new(paginator, self.category)
          client.emit template.render        
        end
      end
    end
  end
end
