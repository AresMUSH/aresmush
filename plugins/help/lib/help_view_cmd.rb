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
          help_url = Help.topic_url(found_topic, search_topic.rest(' '))
          
          lines = md_contents.split("\n")            
          matching_lines = lines.select { |l| l.start_with?("`#{match_topic}")}
          
          if (matching_lines.empty? || self.show_detail)
            footer = "%ld%R#{t('help.help_topic_footer', :url => help_url)}"
            template = BorderedDisplayTemplate.new formatter.to_mush(md_contents), nil, footer
            client.emit template.render
          else            
            list = matching_lines.map { |l| formatter.to_mush(l).strip }
            footer = "%ld%R#{t('help.command_help_footer', :url => help_url, :topic => search_topic)}"
           template = BorderedListTemplate.new list, t('help.command_help_title'), footer
           client.emit template.render
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
