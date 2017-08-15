module AresMUSH
  module Help
    
    class HelpViewCmd
      include CommandHandler

      attr_accessor :topic
      
      def parse_args
        self.topic = cmd.args
      end

      def required_args
        [ self.topic ]
      end
      
      def allow_without_login
        true
      end
      
      def handle               
        topics = Help.find_topic(self.topic)
        if (topics.count == 1)
          topic = topics.first
          md_contents = Help.topic_contents(topic)
          markdown = MarkdownFormatter.new
          template = BorderedDisplayTemplate.new markdown.to_mush(md_contents)
          client.emit template.render
        elsif (topics.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)
        else
          client.emit_failure t('help.not_found_alternatives', :topic => self.topic, :alts => topics.join(", "))
        end
      end
    end
  end
end
