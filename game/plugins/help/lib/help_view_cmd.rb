module AresMUSH
  module Help
    
    class HelpViewCmd
      include CommandHandler

      attr_accessor :category, :topic, :category_config
      
      def parse_args
        self.category = Help.command_to_category(cmd.root)
        self.topic = strip_prefix(titlecase_arg(cmd.args))
        self.category_config = Help.category_config[self.category]
      end

      def required_args
        {
          args: [ self.topic ],
          help: 'help'
        }
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
        found = search_and_display(self.category)
        if (!found)
          Help.category_config.each do |k, v|
            next if v["command"] == self.category_config["command"]
            found = search_and_display(self.category)
            break if found
          end
        end
        
        if (!found)
          client.emit_failure t('help.not_found', :topic => self.topic)
        end
        
      end

      def search_and_display(category)
        found = Help.find_topic(category, self.topic)
        category_title = self.category_config["title"]
        if (found.count == 1)
          display_help(found.first, category_title)
          return true
        elsif (found.count > 1)
          client.emit BorderedDisplay.list(found, t('help.not_found_alternatives', :topic => self.topic))
          return true
        else
          return false
        end
      end
        
      def strip_prefix(arg)
        return nil if !arg
        cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
        !cracked ? nil : cracked[:rest]
      end
            
      def display_help(topic, category_title)
        title = t('help.topic', :category => category_title, :topic => topic.titlecase)
        text = Help.topic_contents(topic, self.category)
        markdown = MarkdownFormatter.new
        display = markdown.to_mush(text).chomp
        client.emit BorderedDisplay.text(display, title)
      end
    end
  end
end
