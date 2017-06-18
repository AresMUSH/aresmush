module AresMUSH
  class HelpReader
    
    attr_accessor :help
    
    def initialize
      self.help = {}
    end

    def load_help_file(file, plugin)
      Global.logger.debug "Loading help from #{file}."
      md = MarkdownFile.new(file)
      md.load_file
      meta = md.metadata
      if (meta)
        topic = File.basename(file, ".md").downcase
        meta["path"] = file
        meta["plugin"] = plugin.downcase
        meta["topic"] = topic
        
        existing_topics = self.help.select { | file, meta | meta['topic'] == topic && meta["plugin"] == plugin.downcase }
        if (existing_topics.count > 0)
          Global.logger.warn "Skipping help file #{file} - topic already exists."
        else
          self.help[file] = meta
        end
      else
        Global.logger.warn "Skipping help file #{file} - missing metadata."
      end
    end
    
    def unload_help(plugin)
      topics = self.help.select { |k, v| v["plugin"] == plugin }
      topics.each { |k, v| self.help.delete(k) }
    end
  end
end