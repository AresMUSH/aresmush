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
        self.topic = HelpSystem.strip_prefix(titleize_input(cmd.args))
      end
      
      def validate_syntax
        return t('dispatcher.invalid_syntax', :command => 'help') if self.category.nil? || self.topic.nil?
        return nil
      end
      
      # TODO - Validate permissions
      
      def handle
        possible_matches = HelpSystem.search_help(self.category, self.topic)
        if (possible_matches.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)
        elsif (possible_matches.count != 1)
          client.emit BorderedDisplay.list(possible_matches, t('help.not_found_alternatives', :topic => self.topic))
        else
          category_title = HelpSystem.category_title(self.category)
          title = t('help.topic', :category => category_title, :topic => self.topic.titlecase)
          begin
            text = HelpSystem.load_help(self.category, possible_matches[0])
          rescue Exception => e
            client.emit_failure t('help.error_loading_help', :topic => topic, :error => e)
            return
          end
          client.emit BorderedDisplay.text(text.chomp, title)
        end
      end
    end
  end
end
