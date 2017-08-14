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
    
    def self.topic_url(plugin, topic)
      "#{Game.web_portal_url}/help/#{plugin}/#{topic.gsub(' ', '_')}"
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
                
        if (k.end_with?('s'))
          all_keys[k.chop] = k.downcase
        end
      end
      
      # Match exact topic
      matches = all_keys.select { |k, v| k == search }
      return matches.values.uniq if matches.count > 0

      # Match partial topic - 'help comb' finds 'help combat'
      matches = all_keys.select { |k, v| k =~ /#{search}/ }
      return matches.values.uniq if matches.count > 0
    end
    
    def self.command_help(command)
      command_text = strip_prefix(command).downcase
      command_text = command_text.gsub(' ', '/')
      fake_cmd = Command.new(command_text)
      CommandAliasParser.substitute_aliases(nil, fake_cmd, Global.plugin_manager.shortcuts)
      Global.plugin_manager.plugins.each do |p|
        handler_class = p.get_cmd_handler(Client.new(0, DummyConnection.new), fake_cmd, nil)
        if (handler_class)
          handler = handler_class.new(nil, nil, nil)
          return handler.help
        end
      end
      
      return nil
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
    
    def self.strip_prefix(arg)
      return nil if !arg
      cracked = /^(?<prefix>[\/\+\=\@]?)(?<rest>.+)/.match(arg)
      !cracked ? nil : cracked[:rest]
    end
    
    class DummyConnection
      def ip_addr
        ""
      end
    end
  end
end
