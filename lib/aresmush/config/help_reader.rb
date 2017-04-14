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
        meta["path"] = file
        meta["plugin"] = plugin
        self.help[file] = meta
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