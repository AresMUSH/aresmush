module AresMUSH
  module Help
    
    class HelpQuickrefCmd
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
        self.topic = Help.strip_prefix(self.topic)
        search_topic = self.topic.gsub('/', ' ').split(' ').first
        
        topics = Help.find_quickref(search_topic)

        if (topics.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)          
          return
        end
        
        list = []
        formatter = MarkdownFormatter.new
        
        topic_keys = topics.values.uniq
        
        topic_keys.each do |found_topic|
          md_contents = Help.topic_contents(found_topic)
          lines = md_contents.split("\n")            
          matching_lines = lines.select { |l| l.start_with?("`#{self.topic}")}
          
          if (!matching_lines.empty?)
            list.concat matching_lines
          end    
        end
        
        help_url = Help.topic_url('')
        text = formatter.to_mush(list.sort.join("\n"))
        footer = t('help.command_help_footer', :url => help_url, :topic => self.topic)
        template = BorderedDisplayTemplate.new text, t('help.command_help_title'), footer
        client.emit template.render
        
      end
    end
  end
end
