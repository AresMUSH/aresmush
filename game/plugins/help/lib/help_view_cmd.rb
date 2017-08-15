module AresMUSH
  module Help
    
    class HelpViewCmd
      include CommandHandler

      attr_accessor :topic, :show_detail
      
      def parse_args
        self.topic = cmd.args
        self.show_detail = cmd.switch_is?("detail")
      end

      def required_args
        [ self.topic ]
      end
      
      def allow_without_login
        true
      end
      
      def handle
        self.topic = Help.strip_prefix(self.topic).gsub('/', ' ')
               
        topics = Help.find_topic(self.topic)
        if (topics.count == 1)
          found_topic = topics.first
          
          if (self.show_detail)
            md_contents = Help.topic_contents(found_topic)
            markdown = MarkdownFormatter.new
            template = BorderedDisplayTemplate.new markdown.to_mush(md_contents)
            client.emit template.render
          else
            client.emit_ooc t('help.view_help_online', 
                :url => Help.topic_url(found_topic, self.topic.rest(' ')),
                :topic => self.topic)
          end
          
        elsif (topics.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)
          
        else
          alts = topics.map { |t| "%% #{Help.topic_url(t)}" }
          client.emit_failure t('help.not_found_alternatives', :topic => self.topic, :alts => topics.join("%R"))
        end
      end
    end
  end
end
