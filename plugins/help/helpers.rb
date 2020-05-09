module AresMUSH
  module Help    
    
    def self.topic_url(topic, search = nil)
      topic = topic.gsub('/', ' ')
      #search_param = search.blank? ? "" : "?search=#{search}"
      #"#{Game.web_portal_url}/help/#{topic}#{search_param}"
      "#{Game.web_portal_url}/help/#{topic}"
    end
    
    # {
    #    section_titleA: [ 'topic1', 'topic2', 'topic3' ],
    #    section_titleB: [ 'topic4', 'topic5' ]
    # }
    def self.toc
      Global.help_reader.help_toc
    end
    
    # {
    #    alias1: cmd1,
    #    alias2: cmd1,
    #    alias3: cmd2
    # }
    def self.topic_keys
      Global.help_reader.help_keys
    end
    
    # {
    #    topic1: { summary: "X", aliases: [], path: "/", etc. },
    #    topic2: { summary: "Y", aliases: [], path: "/", etc. }
    # }
    def self.topic_index
      Global.help_reader.help_file_index
    end
    
    # Given one of the sections from Help.toc (e.g. "section_titleA", returns info about topics in that section):
    # {
    #   "topic1": { summary: "X", aliases: [], path: "/", etc. },
    #   "topic2": { summary: "Y", aliases: [], path: "/", etc. }
    # }
    def self.toc_section_topic_data(section)
      topics = {}
      topic_names = Help.toc[section]
      topic_names.each do |topic|
        topics[topic] = Help.topic_index[topic]
      end
      topics
    end
    
    # Finds topic keys that are a partial match for the command being searched.
    def self.find_quickref(topic)
      search = strip_prefix(topic).downcase.gsub(/[\/ ]/, "_")
      search = search.split("_").first
      return Help.topic_keys.select { |k, v| k =~ /#{search}/ }
    end
        
    # Finds topic keys for topic names and aliases matching the search string - with some added logic
    # to account for plurals, partials.
    def self.find_topic(topic)
      search = strip_prefix(topic).downcase.gsub(/[\/ ]/, "_")
            
      # Match exact topic
      matches = Help.topic_keys.select { |k, v| k == search }
      return matches.values.uniq if matches.count > 0

      # Match first part - 'help forum edit' matches 'help forum'
      matches = Help.topic_keys.select { |k, v| k == search.first('_') }
      return matches.values.uniq if matches.count > 0

      # Match partial topic - 'help comb' finds 'help combat'
      matches = Help.topic_keys.select { |k, v| k =~ /#{search}/ }
      return matches.values.uniq if matches.count > 0

      # Match plurals
      matches = Help.topic_keys.select { |k, v| k == "#{search}s" }
      return matches.values.uniq if matches.count > 0
      
      # Match both 'help manage combat' and 'help combat manage'
      if (search.end_with?("_manage"))
        manage_topic = search.gsub("_manage", "")
        manage_topic = "manage_#{manage_topic}"
        matches = Help.topic_keys.select { |k, v| k == "#{manage_topic}" }
        return matches.values.uniq if matches.count > 0
      end
      if (search.start_with?("manage_"))
        manage_topic = search.gsub("manage_", "")
        manage_topic = "#{manage_topic}_manage"
        matches = Help.topic_keys.select { |k, v| k == "#{manage_topic}" }
        return matches.values.uniq if matches.count > 0
      end
      return []
    end
   
    def self.topic_contents(topic_key)
      topic = Global.help_reader.help_text[topic_key]
      raise "Help topic #{topic_key} not found!" if !topic
      topic
    end
    
    def self.strip_prefix(arg)
      return nil if !arg
      cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
      !cracked ? nil : cracked[:rest]
    end
    
    # @engineinternal true
    def self.tutorial_files
      search = File.join(AresMUSH.game_path, "tutorials", "**.md")
      Dir[search]
    end
    
    # Given a topic name (e.g. 'channels')
    # returns other topics in the same toc section.
    def self.related_topics(topic)
      topic_data = Help.topic_index[topic]
      return [] if (!topic_data['toc'])
      related = Help.toc_section_topic_data(topic_data['toc']) || {}
      related.select { |k, v| k != topic }.sort_by { |k, v| [ v['tutorial'] ? 0 : 1, k ] }.map { |k, v| k}
    end
    
  end
end
