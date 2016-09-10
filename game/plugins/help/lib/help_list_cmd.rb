module AresMUSH
  module Help
    
    class HelpListCmd
      include CommandHandler
      include CommandWithoutSwitches

      attr_accessor :category, :page
      
      def want_command?(client, cmd)
        cmd.root.end_with?("help") && !cmd.args
      end

      def crack!
        self.category = Help.command_to_category(cmd.root)
        self.page = cmd.page.nil? ? 1 : cmd.page.to_i
      end
      
      def check_valid_category
        return t('help.unrecognized_help_library') if !self.category
        return nil
      end
        
      def check_can_view_help
        return nil if !self.category
        return t('dispatcher.not_allowed') if !Help.can_access_help?(client.char, self.category)
        return nil
      end
      
      def handle
        list = []
        
        Help.toc(self.category).each do |toc|
          list << "%xg#{toc}%xn"
          Help.toc_topics(category, toc).each do |title, data|
            list << "%T%xh#{title.titleize}%xn - #{data["summary"]}"
          end
        end
        
        title = t('help.toc', :category => self.category["title"])
        
        client.emit BorderedDisplay.paged_list(list, self.page, 20, title, footer)
      end
      
      def footer
        footer = "%l2%r"
        footer << "%xh#{t('help.other_help_libraries')}%xn"
        Help.category_config.each do |c, v|
          footer << " \[#{v['command']}\] #{v['title']}"
        end
        footer
      end
    end
  end
end
