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
        begin
          text = HelpSystem.find_help(self.category, self.topic)
        rescue Exception => e
          client.emit_failure t('help.error_loading_help', :topic => topic, :error => e)
          return
        end
        
        if text.nil?
          possible_matches = HelpSystem.search_topics(self.category, self.topic)
          if (possible_matches.empty?)
            client.emit_failure t('help.not_found', :topic => self.topic)
          else
            client.emit BorderedDisplay.list(possible_matches, t('help.not_found_alternatives', :topic => self.topic))
          end
        else        
          category_title = HelpSystem.category_title(self.category)
          title = t('help.topic', :category => category_title, :topic => self.topic)
          client.emit BorderedDisplay.text(text.chomp, title)
        end
      end
    end
  end
end
