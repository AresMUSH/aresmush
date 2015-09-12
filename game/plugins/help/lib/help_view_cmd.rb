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
        found = find_match(self.category)
        if (!found)
          Help.valid_commands.each do |c|
            cat = Help.category_for_command(c)
            found = find_match(cat)
            return if found
          end
          client.emit_failure t('help.not_found', :topic => self.topic)
        end
      end
      
      def find_match(cat)
        possible_matches = Help.search_help(cat, self.topic)
        exact_matches = possible_matches.select { |h| h == self.topic }

        if (exact_matches.count == 1)
          display_help(exact_matches[0], cat)
          return true
        elsif (possible_matches.count == 1)
          display_help(possible_matches[0], cat)
          return true
        elsif (possible_matches.count > 1)
          client.emit BorderedDisplay.list(possible_matches, t('help.not_found_alternatives', :topic => self.topic))
          return true
        else
          return false
        end
      end
      
      def display_help(match, cat)
        EM.defer do 
          AresMUSH.with_error_handling(client, "Getting help file:") do            
            category_title = Help.category_title(cat)
            title = t('help.topic', :category => category_title, :topic => self.topic.titlecase)
            begin
              text = Help.load_help(cat, match)
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
end
