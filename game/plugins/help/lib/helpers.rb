module AresMUSH
  module Help    
    mattr_accessor :help_topics
    
    def initialize
      Help.help_topics = nil
    end
    
    def self.index
      if (!Help.help_topics)
        Help.reload_help
      end
      Help.help_topics || {}
    end
    
    def self.toc
      topics = Help.index
      topics.select{ |k, v| v["toc"] }.map { |k, v| v["toc"] }.uniq.sort
    end
    
    def self.toc_topics(toc)
      all_topics = Help.index
      all_topics.select { |k, v| v["toc"] == toc }.sort_by { |k, v| [ v["order"] || 50, v["topic"] ] }
    end    
    
    def self.find_topic(topic)
      index = Help.index
      search = topic.downcase

      all_keys = {}
      index.each do |k, v|
        all_keys[k.downcase] = k.downcase
        if (v["aliases"])
          v["aliases"].each do |a|
            all_keys[a.downcase] = k.downcase
          end
        end
        
        plugin_name = k.first(' ')
        if (plugin_name.end_with?('s'))
          singular = plugin_name.chop
          all_keys["#{singular} #{k.rest(' ')}"] = k.downcase
        end
        
        if (k.end_with?('s'))
          all_keys[k.chop] = k.downcase
        end
      end
      
      matches = all_keys.select { |k, v| k == search }
      return matches.values.uniq if matches.count > 0

      matches = all_keys.select { |k, v| k =~ /#{search}/ }
      matches.values.uniq
    end
    
    def self.topic_contents(topic_key)
      Global.logger.debug "Reading help file #{topic_key}"
      index = Help.index
      topic = index[topic_key]
      raise "Help topic #{topic_key} not found!  Available: #{index.keys.join(' ')} " if !topic
      path = topic["path"]
      md = MarkdownFile.new(path)
      md.contents
    end
    
    def self.reload_help
      Help.help_topics = {}

      all_help = Global.help_reader.help

      [ nil, Global.locale.default_locale, Global.locale.locale ].each do |locale|
        Global.logger.info "Loading help for #{locale}."
        
         all_help.select { |h, v| v["locale"] == locale }.each do |path, value|
           
           file_name = File.basename( value["path"], ".md" ).gsub('_', ' ')
           plugin = value["plugin"]
           if (file_name == "index")
             key = plugin
             value["order"] = 1
             if (!value["aliases"])
               value["aliases"] = [ file_name ]
             else
               value["aliases"] << file_name
             end
           else
             key = "#{plugin} #{file_name}"
           end
           
           Help.help_topics[key] = value
         end
       end
    end
  end
end
