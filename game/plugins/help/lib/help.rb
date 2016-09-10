module AresMUSH
  module Help    
    mattr_accessor :help_topics
    
    def initialize
      Help.help_topics = nil
    end
    
    def self.category_config
      Global.read_config("help", "categories")
    end
    
    def self.index(category = "main")
      if (!Help.help_topics)
        Help.load_help
      end
      Help.help_topics[category] || {}
    end
    
    def self.command_to_category(command_root)
      match = Help.category_config.select { |k, v| v["command"].upcase == command_root.upcase }
      puts match.inspect
      match.empty? ? nil : match.keys[0]
    end
    
    def self.can_access_help?(char, category)
      config = Help.category_config[category]
      roles = config ? config["roles"] : []
      return true if !roles
      return char.has_any_role?(roles)
    end
    
    def self.toc(category)
      topics = Help.index(category)
      topics.map { |k, v| v["toc"] }.uniq.sort
    end
    
    def self.toc_topics(category, toc)
      all_topics = Help.index(category)
      all_topics.select { |k, v| v["toc"] == toc }.sort_by { |k, v| v["topic"] }
    end    
    
    def self.find_topic(category, topic)
      index = Help.index(category)
      search = topic.downcase

      all_keys = {}
      index.each do |k, v|
        all_keys[k.downcase] = k.downcase
        if (v["aliases"])
          v["aliases"].each do |a|
            all_keys[a.downcase] = k.downcase
          end
        end
      end
      
      matches = all_keys.select { |k, v| k == search }
      return matches.values.uniq if matches.count > 0

      matches = all_keys.select { |k, v| k =~ /#{search}/ }
      matches.values.uniq
    end
    
    def self.topic_contents(topic_key, category = "main")
      Global.logger.debug "Reading help file #{category}:#{topic_key}"
      index = Help.index(category)
      topic = index[topic_key]
      path = topic["path"]
      md = MarkdownFile.new(path)
      md.contents
    end
    
    def self.load_help
      files = PluginManager.help_files
      Help.help_topics = {}

      all_help = {}
      files.each do |f|
        begin
          reader = MarkdownFile.new f
          all_help[f] = reader.metadata
        rescue Exception => ex
          Global.logger.warn "Error loading help file.  Skipping #{f}.  Problem: #{ex}"
        end
      end
      
      [ nil, Global.locale.default_locale, Global.locale.locale ].each do |locale|
        Global.logger.info "Loading help for #{locale}."
        
         all_help.select { |h, v| v["locale"] == locale }.each do |path, value|
           Global.logger.debug "Loading help from #{path}."
           
           key = value["topic"]
           categories = value["categories"]
           
           categories.each do |cat|
             if (!Help.help_topics[cat])
               Help.help_topics[cat] = {}
             end
             Help.help_topics[cat][key] = value
             Help.help_topics[cat][key]["path"] = path
           end
         end
       end
    end
  end
end
