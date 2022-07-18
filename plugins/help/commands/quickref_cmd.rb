module AresMUSH
  module Help
    
    class HelpQuickrefCmd
      include CommandHandler

      attr_accessor :topic
      
      def parse_args
        self.topic = cmd.args || "help"
      end

      def required_args
        [ self.topic ]
      end
      
      def allow_without_login
        true
      end
      
      def handle
        if (self.topic.end_with?("s"))
          self.topic = self.topic.chop
        end
        self.topic = Help.strip_prefix(self.topic)
        search_topic = self.topic.gsub('/', ' ').split(' ').first
        
        topic_keys = Help.find_quickref(search_topic)

        if (topic_keys.empty?)
          client.emit_failure t('help.not_found', :topic => self.topic)          
          return
        end
        
        list = []
        manage_list = []
                
        topic_keys.each do |found_topic|
          meta = Help.topic_index[found_topic]
          md_contents = Help.topic_contents(found_topic)
          lines = md_contents.split("\n")
          matching_lines = lines.select { |l| line_is_match?(l) }
          
          if (!matching_lines.empty?)
            if (found_topic.start_with?("manage") || meta["toc"].start_with?("~admin~"))
              manage_list.concat matching_lines          
            else
              list.concat matching_lines
            end    
          end
        end
        
        if (list.empty? && manage_list.empty?)
          client.emit_failure t('help.not_found', :topic => self.topic)          
          return
        end
        
        help_url = Help.topic_url('')
        template = QuickrefTemplate.new(list, manage_list)
        client.emit template.render        
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
