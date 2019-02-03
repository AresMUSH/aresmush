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
          matching_lines = lines.select { |l| line_is_match?(l) }
          
          if (!matching_lines.empty?)
            list.concat matching_lines
          end    
        end
        
        help_url = Help.topic_url('')
        text = formatter.to_mush(list.sort.join("\n"))
        #template = BorderedDisplayTemplate.new text
        #client.emit template.render
        client.emit "%lh#{text}%lf"
        
      end
      
      def line_is_match?(line)
        search = self.topic
        return true if line.start_with?("`#{search}")
        
        search = self.topic.gsub(' ', '/')
        return line.start_with?("`#{search}")
      end
    end
  end
end
