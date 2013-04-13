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
      File.join(AresMUSH.game_path, "plugins")
    end
    
    def self.locale_files
      Dir[File.join(PluginManager.plugin_path, "**", "locale*.yml")]
    end

    def self.help_files
      Dir[File.join(PluginManager.plugin_path, "**", "help*.yml")]
    end
    
    def self.config_files
      Dir[File.join(PluginManager.plugin_path, "**", "config*.yml")]
    end
    
    def self.plugin_files(name = "*")
      all_files = Dir[File.join(PluginManager.plugin_path, name, "**", "*.rb")]
      all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
    end
    
    def load_all
      load_plugin_code(PluginManager.plugin_files)
    end
    
    def interface(name)
      found = plugins.select { |p| p.class.to_s == "AresMUSH::#{name}" }
      return nil if found.empty?
      return found[0]      
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