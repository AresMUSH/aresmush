module AresMUSH
  class HelpReader
    
    attr_accessor :help_file_index, :help_toc, :help_keys, :help_text, :help_commands
    
    def initialize
      self.clear_help
    end
    
    def clear_help
      self.help_file_index = {}
      self.help_toc = {}
      self.help_keys = {}
      self.help_text = {}
      self.help_commands = {}
    end
    
    def load_game_help
      Global.locale.locale_order.each do |locale|
        files = help_files(locale)
        files.each do |path|              
          Global.help_reader.load_help_file path, "game"
        end
      end
    end
    
    # @engineinternal true
    def load_help_file(file, plugin)      
      plugin_title = plugin ? plugin.downcase : ""
      
      md = MarkdownFile.new(file)
      md.load_file
      meta = md.metadata
      if (meta)
        topic = File.basename(file, ".md").downcase
        meta["path"] = file
        meta["plugin"] = plugin_title
        meta["topic"] = topic
        meta["override"] = plugin == "game" ? true : false
        toc = meta["toc"] || "Miscellaneous"
        
        if self.help_file_index.has_key?(topic)
          Global.logger.warn "Skipping help file #{file} - topic already exists."
        else
          self.help_file_index[topic] = meta
          if (self.help_toc.has_key?(toc))            
            self.help_toc[toc] << topic
          else
            self.help_toc[toc] = [ topic ]
          end
          self.help_keys[topic] = topic
          if (topic.end_with?('s'))
            self.help_keys[topic.chop] = topic
          else 
            self.help_keys["#{topic}s"] = topic
          end
          (meta['aliases'] || []).each do |a|
            self.help_keys[a] = topic
          end
          
          lines = md.contents.split("\n")
          lines.each do |l|
            if (l.start_with?("`"))
              if (l =~ /([^`]+)/)
                command_str = $1
                if (self.help_commands.has_key?(command_str))
                  self.help_commands[command_str] << topic
                else
                  self.help_commands[command_str] = [ topic ]
                end
              end
            end
          end
          
          self.help_text[topic] = md.contents
        end
        
      else
        Global.logger.warn "Skipping help file #{file} - missing metadata."
      end
    end
    
    def unload_help(plugin)
      topics = self.help_file_index.select { |k, v| v["plugin"] == plugin }
      topics.each do |topic, val| 
        self.help_file_index.delete topic
        self.help_toc.each do |toc, val|
          if (self.help_toc[toc].include?(topic))
            self.help_toc[toc].delete topic
          end
        end
      end
      
      keys = self.help_keys.select { |k, v| topics.include?(v) }
      keys.each { |k| self.help_keys.delete k }
    end
    
    private
    

    def game_help_path
      File.join(AresMUSH.game_path, "help") 
    end
    
    # @engineinternal true
    def help_files(locale)
      search = File.join(game_help_path, locale, "**.md")
      Dir[search]
    end
    
  end
end