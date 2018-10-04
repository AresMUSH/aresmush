module AresMUSH
  module Help    
    
    def self.topic_url(topic, search = nil)
      topic = topic.gsub('/', ' ')
      #search_param = search.blank? ? "" : "?search=#{search}"
      #"#{Game.web_portal_url}/help/#{topic}#{search_param}"
      "#{Game.web_portal_url}/help/#{topic}"
    end
    
    def self.toc
      Global.help_reader.help_toc
    end
    
    def self.topic_keys
      Global.help_reader.help_keys
    end
    
    def self.topic_index
      Global.help_reader.help_file_index
    end
    
    def self.toc_section_topic_data(section)
      topics = {}
      topic_names = Help.toc[section]
      topic_names.each do |topic|
        topics[topic] = Help.topic_index[topic]
      end
      topics
    end
    
    def self.find_quickref(topic)
      search = strip_prefix(topic).downcase.gsub(/[\/ ]/, "_")
      search = search.split("_").first
      return Help.topic_keys.select { |k, v| k =~ /#{search}/ }
    end
        
    
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
      Global.logger.debug "Reading help file #{topic_key}"
      topic = Help.topic_index[topic_key]
      raise "Help topic #{topic_key} not found!" if !topic
      path = topic["path"]
      md = MarkdownFile.new(path)
      md.contents
    end
    
    def self.strip_prefix(arg)
      return nil if !arg
      cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
      !cracked ? nil : cracked[:rest]
    end
    
  end
end
