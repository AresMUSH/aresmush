module AresMUSH
  module Help
    
    class HelpViewCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :category
      attr_accessor :topic
      
      def initialize
        self.required_args = ['category', 'topic']
        self.help_topic = 'help'
        super
      end
            
      def want_command?(client, cmd)
        Help.valid_commands.include?(cmd.root) && !cmd.args.nil?
      end
      
      def crack!
        self.category = Help.category_for_command(cmd.root)
        self.topic = Help.strip_prefix(titleize_input(cmd.args))
      end
      
      def check_can_view_help
        return t('dispatcher.not_allowed') if !Help.can_access_help?(client.char, self.category)
        return nil
      end
      
      def handle
        possible_matches = Help.search_help(self.category, self.topic)
        if (possible_matches.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)
        elsif (possible_matches.count != 1)
          client.emit BorderedDisplay.list(possible_matches, t('help.not_found_alternatives', :topic => self.topic))
        else
          category_title = Help.category_title(self.category)
          title = t('help.topic', :category => category_title, :topic => self.topic.titlecase)
          begin
            text = Help.load_help(self.category, possible_matches[0])
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
