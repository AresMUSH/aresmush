module AresMUSH
  class HelpReader
    
    attr_accessor :help
    
    def initialize
      self.help = {}
    end
    
    def load_game_help
      Global.locale.locale_order.each do |locale|
        files = help_files(locale)
        files.each do |path|              
          Global.help_reader.load_help_file path, "game"
        end
      end
    end
    
    def load_help_file(file, plugin)
      Global.logger.debug "Loading help from #{file}."
      
      plugin_title = plugin ? plugin.downcase : ""
      
      md = MarkdownFile.new(file)
      md.load_file
      meta = md.metadata
      if (meta)
        topic = File.basename(file, ".md").downcase
        meta["path"] = file
        meta["plugin"] = plugin_title
        meta["topic"] = topic
        
        existing_topics = self.help.select { | file, meta | meta['topic'] == topic && meta["plugin"] == plugin_title }
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
    
    private
    

    def game_help_path
      File.join(AresMUSH.game_path, "help") 
    end
    
    def help_files(locale)
      search = File.join(game_help_path, locale, "**.md")
      Dir[search]
    end
    
  end
end