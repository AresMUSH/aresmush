module AresMUSH
  module Help
    
    def self.categories
      Global.config["help"]["categories"]
    end
        
    def self.topics(category)
      Help.category(category)["topics"]
    end
    
    def self.valid_commands
      Help.categories.values.map { |c| c["command"] }
    end
    
    def self.category_for_command(command_root)
      Help.categories.keys.find { |k| categories[k]["command"].upcase == command_root.upcase }
    end
    
    def self.category_toc(name)
      topics = Help.topics(name)
      toc = topics.values.map { |t| t["toc_topic"] }
      toc = toc.uniq
      toc.delete(nil)
      toc
    end
    
    def self.topics_for_toc(category, toc)
      topics = Help.topics(category).sort_by { |k, v| v["order"].nil? ? 99 : v["order"] }
      topics.select { |k, v| !v["toc_topic"].nil? && v["toc_topic"] == toc }
    end
    
    def self.category_title(name)
      category = Help.category(name)
      title = category.nil? ? "" : category["title"]
      title
    end
    
    def self.is_alias?(entry_to_search, topic)
      aliases = entry_to_search['aliases']
      return false if aliases.nil?
      downcased_aliases = aliases.map(&:downcase)
      downcased_aliases.include?(topic.downcase)
    end

    def self.strip_prefix(topic)
      cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(topic)
      cracked.nil? ? nil : cracked[:rest]
    end
    
    def self.search_help(category, topic)
      topics = Help.topics(category)
      return [] if topics.nil?

      matching_alias = topics.keys.find { |t| Help.is_alias?(topics[t], topic) }
      return [matching_alias.titlecase] if !matching_alias.nil?
      
      downcased_topic_keys = topics.keys.map(&:downcase)
      downcased_topic = topic.downcase
      matching_topics = downcased_topic_keys.select { |k| k =~ /#{downcased_topic}/ }
      matching_topics.map { |k| k.titlecase }
    end
    
    def self.load_help(category, topic_key)
      topic = Help.topic(category, topic_key)
      raise "Topic not found" if topic.nil?
      raise "Help topic misconfigured" if topic["file"].nil? || topic["dir"].nil?
      filename = File.join(topic["dir"], Global.locale.locale.to_s, topic["file"])
      # If current locale not found, try the default locale
      if (!File.exists?(filename))
        filename = File.join(topic["dir"], Global.locale.default_locale.to_s, topic["file"])
      end
      File.read(filename, :encoding => "UTF-8")
    end
    
    # Careful with this one - name must be pre-stripped if user input
    def self.category(name)
      categories[name.downcase]
    end

    # Careful with this one - name must be pre-stripped if user input
    def self.topic(category, topic)
      Help.category(category)["topics"][topic.downcase]
    end
    
    def self.can_access_help?(char, category)
      roles = Help.category(category)["roles"]
      return true if roles.nil?
      return char.has_any_role?(roles)
    end
  end
end
