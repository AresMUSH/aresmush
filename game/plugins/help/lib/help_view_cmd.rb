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
        self.topic = Help.strip_prefix(self.topic)
        search_topic = self.topic.gsub('/', ' ')
        match_topic = self.topic.gsub(' ', '/')
        
        topics = Help.find_topic(search_topic)
        if (topics.count == 1)
          found_topic = topics.first
          formatter = MarkdownFormatter.new
          md_contents = Help.topic_contents(found_topic)
          
          if (self.show_detail)
            template = BorderedDisplayTemplate.new formatter.to_mush(md_contents)
            client.emit template.render
          else
            lines = md_contents.split("\n")
            help_url = Help.topic_url(found_topic, search_topic.rest(' '))
            
            matching_lines = lines.select { |l| l.start_with?("`#{match_topic}")}
            if (matching_lines.empty?)
              client.emit_ooc t('help.view_help_online', 
                  :url => help_url,
                  :topic => search_topic)
            else            
              help_tip = t('help.command_help', 
                 :url => help_url,
                 :topic => search_topic)
              matching_lines << help_tip 
              client.emit matching_lines.map { |l| "%xx%xh%%%xn #{formatter.to_mush(l).strip}" }.join("\n")
            end    
          end
          
        elsif (topics.count == 0)
          client.emit_failure t('help.not_found', :topic => self.topic)          
        else
          alts = topics.map { |t| "%% #{Help.topic_url(t)}" }
          client.emit_failure t('help.not_found_alternatives', :topic => search_topic, :alts => topics.join("%R"))
        end
      end
    end
  end
end
