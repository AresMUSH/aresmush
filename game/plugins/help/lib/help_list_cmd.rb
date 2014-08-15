module AresMUSH
  module Help
    
    class HelpListCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :category, :page
      
      def initialize
        self.required_args = ['category']
        self.help_topic = 'help'
        super
      end
            
      def want_command?(client, cmd)
        Help.valid_commands.include?(cmd.root) && cmd.args.nil?
      end

      def crack!
        self.category = Help.category_for_command(cmd.root)
        self.page = cmd.page.nil? ? 1 : cmd.page.to_i
      end
      
      def check_can_view_help
        return t('dispatcher.not_allowed') if !Help.can_access_help?(client.char, self.category)
        return nil
      end
      
      def handle
        toc = Help.category_toc(self.category)
        text = []
        toc.sort.each do |toc_key|
          text << "%xg#{toc_key.titleize}%xn"
          entries = Help.topics_for_toc(self.category, toc_key).sort
          entries.each do |entry_key|
            entry = Help.topic(self.category, entry_key)
            text << "     %xh#{entry_key.titleize}%xn - #{entry["summary"]}"
          end
        end
        categories = Help.categories.select { |c| c != self.category }
        
        title = t('help.toc', :category => Help.category_title(self.category))
        footer = ""
        if (!categories.empty?)
          footer << "%l2%r"
          footer << "%xh#{t('help.other_help_libraries')}%xn"
          categories.keys.each do |category|
            footer << " \[#{categories[category]['command']}\] #{categories[category]['title']}"
          end
        end
        client.emit BorderedDisplay.paged_list(text, self.page, 20, title, footer)
      end
    end
  end
end
