module AresMUSH
  module Help
    
    class HelpCmd
      include AresMUSH::Plugin

      attr_accessor :category
      attr_accessor :topic
            
      def want_command?(client, cmd)
        Help.valid_commands.include?(cmd.root) && !cmd.args.nil?
      end
      
      def crack!
        self.category = Help.category_for_command(cmd.root)
        self.topic = cmd.args.titlecase
      end
      
      # TODO - Validate permissions
      
      def handle
        text = Help.find_help(self.category, self.topic)
        if text.nil?
          possible_matches = Help.find_possible_topics(self.category, self.topic)
          client.emit BorderedDisplay.list(, t('help.not_found', :topic => self.topic))
        else        
          category_title = Help.category_title(self.category)
          title = t('help.topic', :category => category_title, :topic => self.topic)
          client.emit BorderedDisplay.text(text.chomp, title.center(78))
        end
      end
    end
  end
end
