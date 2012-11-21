require 'ansi'

module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class PluginManager
    def initialize(plugin_factory)
      @plugin_factory = plugin_factory
      @plugins = []
    end
    
    attr_reader :plugins
    
    def self.plugin_path
      File.join(AresMUSH.game_dir, "plugins")
    end
    
    def self.locale_files
      Dir[File.join(PluginManager.plugin_path, "*", "locales", "**")]
    end
    
    def self.config_files
      Dir[File.join(PluginManager.plugin_path, "*", "config", "**")]
    end
    
    def self.plugin_files(name = "*")
      Dir[File.join(PluginManager.plugin_path, name, "lib", "**", "*.rb")]
    end
    
    def load_all
      load_plugin_code(PluginManager.plugin_files)
    end
    
    def load_plugin(name)
      plugin_files = PluginManager.plugin_files(name)
      raise SystemNotFoundException if plugin_files.empty?
      load_plugin_code(plugin_files)
    end
    
      
    private    
    def load_plugin_code(files)
      files.each do |f| 
        logger.info "Loading #{f}."
        load f
      end
      @plugins = @plugin_factory.create_plugin_classes
    end 
  end
end