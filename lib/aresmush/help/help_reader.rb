module AresMUSH
  class HelpReader
    def initialize
      clear_help
    end

    def self.help
      @@help
    end
    
    def self.help_path
      File.join(AresMUSH.game_path, "help") 
    end

    def self.help_files
      Dir[File.join(HelpReader.help_path, "**")]
    end
    
    def categories
      Global.config['help']['categories']
    end
    
    def help
      @@help
    end
    
    def clear_help
      @@help = {}
    end

    def read
      plugin_help = PluginManager.help_files
      @@help = YamlFileParser.read(HelpReader.help_files, {} )
      @@help = YamlFileParser.read(plugin_help, @@help)
    end    
  end
end
