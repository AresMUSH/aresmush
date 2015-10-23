module AresMUSH
  module Help
    
    class HelpViewCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :category_index
      attr_accessor :topic
      
      def initialize
        self.required_args = ['topic']
        self.help_topic = 'help'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root.end_with?("help") && cmd.args
      end
      
      def crack!
        self.category_index = Help.command_to_category_index(cmd.root)
        self.topic = strip_prefix(titleize_input(cmd.args))
      end
      
      def check_valid_category
        return t('help.unrecognized_help_library') if !self.category_index
        return nil
      end
      
      def check_can_view_help
        return nil if !self.category_index
        return t('dispatcher.not_allowed') if !Help.can_access_help?(client.char, self.category_index)
        return nil
      end
      
      def handle
        Global.dispatcher.spawn("Getting help file:", client) do      
          found = find_match(self.category_index)
          if (!found)
            Help.categories.each do |k, v|
              next if v["command"] == self.category_index["command"]
              found = find_match(v)
              break if found
            end
            client.emit_failure t('help.not_found', :topic => self.topic) if !found
          end
        end
      end
      
      def strip_prefix(arg)
        return nil if !arg
        cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
        cracked.nil? ? nil : cracked[:rest]
      end
      
      def topic_keys(index)
        topics = index["topics"]
        topic_keys = {}
      
        topics.each do |topic, entry|
          topic_keys[topic] = topic
          if (entry["aliases"])
            entry["aliases"].each do |a|
              topic_keys[a] = topic
            end
          end
        end
      
        topic_keys
      end
      
      def find_match(index)
        exact_matches = topic_keys(index).select { |k, v| k.downcase == self.topic.downcase}
        partial_matches = topic_keys(index).select { |k, v| k.downcase =~ /#{self.topic.downcase}/}

        # Matches return a hash like  { name => key, name => key }.  We grab the first one, which gives us [name, key]
        # they use [1] to get the key
        if (exact_matches.count == 1)
          display_help(exact_matches.first[1], index)
          return true
        elsif (partial_matches.count == 1)
          display_help(partial_matches.first[1], index)
          return true
        elsif (partial_matches.count > 1)
          client.emit BorderedDisplay.list(partial_matches.keys, t('help.not_found_alternatives', :topic => self.topic))
          return true
        else
          return false
        end
      end
      
      def display_help(topic_key, index)
        category_title = index["title"]
        title = t('help.topic', :category => category_title, :topic => topic_key.titleize)
        begin
          text = Help.load_help(topic_key, index)
          client.emit BorderedDisplay.text(text.chomp, title)
        rescue Exception => e
          client.emit_failure t('help.error_loading_help', :topic => topic_key, :error => e)
        end
      end
    end
  end
end
