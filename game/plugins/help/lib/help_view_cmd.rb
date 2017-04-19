module AresMUSH
  module Help
    
    class HelpViewCmd
      include CommandHandler

      attr_accessor :topic
      
      def parse_args
        self.topic = strip_prefix(titlecase_arg(cmd.args))
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
      
      def handle
        found = Help.find_topic(self.topic)
        if (found.count == 1)
          display_help(found.first)
        elsif (found.count > 1)
          client.emit BorderedDisplay.list(found, t('help.not_found_alternatives', :topic => self.topic))
        else
          client.emit_failure t('help.not_found', :topic => self.topic)
        end
      end
        
      def strip_prefix(arg)
        return nil if !arg
        cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
        !cracked ? nil : cracked[:rest]
      end
            
      def display_help(topic)
        text = Help.topic_contents(topic)
        markdown = MarkdownFormatter.new
        display = markdown.to_mush(text).chomp
        client.emit BorderedDisplay.text display
      end
    end
  end
end
