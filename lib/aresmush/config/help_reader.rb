module AresMUSH
  class HelpReader
    
    attr_accessor :help
    
    def initialize
      self.help = {}
    end

    def load_help_file(file)
      Global.logger.debug "Loading help from #{file}."
      md = MarkdownFile.new(file)
      md.load_file
      meta = md.metadata
      meta["path"] = file
      self.help[file] = meta
    end
    
    def unload_help(plugin)
      topics = self.help.select { |k, v| v["plugin"] == plugin }
      topics.each { |k, v| self.help.delete(k) }
    end
  end
end