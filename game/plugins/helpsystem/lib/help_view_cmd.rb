module AresMUSH
  module HelpSystem
    
    class HelpViewCmd
      include AresMUSH::Plugin

      attr_accessor :category
      attr_accessor :topic
      
      no_switches
            
      def want_command?(client, cmd)
        HelpSystem.valid_commands.include?(cmd.root) && !cmd.args.nil?
      end
      
      def crack!
        self.category = HelpSystem.category_for_command(cmd.root)
        self.topic = titleize_input(cmd.args)
      end
      
      # TODO - Validate permissions
      
      def handle
        topic_alias = HelpSystem.lookup_alias(self.category, self.topic)
        if (!topic_alias.nil?)
          self.topic = topic_alias
        end
        
        begin
          possible_matches = HelpSystem.search_help(self.category, self.topic)
          if (possible_matches.count == 0)
            client.emit_failure t('help.not_found', :topic => self.topic)
          elsif (possible_matches.count != 1)
            client.emit BorderedDisplay.list(possible_matches, t('help.not_found_alternatives', :topic => self.topic))
          else
            category_title = HelpSystem.category_title(self.category)
            title = t('help.topic', :category => category_title, :topic => self.topic.titlecase)
            text = HelpSystem.load_help(self.category, possible_matches[0])
            client.emit BorderedDisplay.text(text.chomp, title)
          end
        rescue Exception => e
          client.emit_failure t('help.error_loading_help', :topic => topic, :error => e)
          return
        end
      end
    end
  end
end
