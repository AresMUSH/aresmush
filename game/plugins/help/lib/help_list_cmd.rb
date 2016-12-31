module AresMUSH
  module Help
    class HelpListCmd
      include CommandHandler
      include CommandWithoutSwitches

      attr_accessor :category, :page
      
      def crack!
        self.category = Help.command_to_category(cmd.root)
        self.page = !cmd.page ? 1 : cmd.page.to_i
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
        case self.category
        when "main"
          topics_per_page = 3
        when "admin"
          topics_per_page = 5
        when "builder"
          topics_per_page = 6
        else
          topics_per_page = 4
        end
            
        paginator = Paginator.paginate(list, self.page, topics_per_page)
        
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
