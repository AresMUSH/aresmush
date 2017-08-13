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
        command_text = strip_prefix(self.topic).downcase
        command_text = command_text.gsub(' ', '/')
        fake_cmd = Command.new(command_text)
        CommandAliasParser.substitute_aliases(enactor, fake_cmd, Global.plugin_manager.shortcuts)
        Global.plugin_manager.plugins.each do |p|
          handler_class = p.get_cmd_handler(client, fake_cmd, enactor)
          if (handler_class)
            handler = handler_class.new(nil, nil, nil)
            client.emit "%xh%xx%%%xn #{handler.help_text}"
            return
          end
        end
        
        topics = Help.find_topic(self.topic)
        if (topics.any?)
          
          help_url = topics.map { |t| Help.topic_url(t) }.join(', ')
        else
          help_url = "#{Game.web_portal_url}/help"
          
          plugin_names = Global.plugin_manager.plugins.map { |p| p.to_s.after("::").downcase}
          if (plugin_names.include?(fake_cmd.root))
            help_url = "#{help_url}/#{fake_cmd.root}"
          end
        end
        
        client.emit_failure t('help.no_help_found', :command => self.topic, :url => help_url)
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

        template = BorderedDisplayTemplate.new display
        client.emit template.render
      end
    end
  end
end
