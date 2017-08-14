module AresMUSH
  module Help
    
    class HelpViewCmd
      include CommandHandler

      attr_accessor :topic
      
      def parse_args
        self.topic = cmd.args
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
        
        command_help = Help.command_help(self.topic)
        help_url = "#{Game.web_portal_url}/help"
        
        if (command_help)
          markdown = MarkdownFormatter.new
          template = BorderedDisplayTemplate.new markdown.to_mush(command_help),
                t('help.help_topic_header', :command => self.topic),
                t('help.help_topic_footer', :url => help_url)

          client.emit template.render
          return
        end
        
        topics = Help.find_topic(self.topic)        
        if (topics.any?)
          help_url = topics.map { |t| Help.topic_url(Help.index[t]['plugin'], t) }.join(', ')
        end
        
        client.emit_failure t('help.no_help_found', :command => self.topic, :url => help_url)
      end
    end
  end
end
