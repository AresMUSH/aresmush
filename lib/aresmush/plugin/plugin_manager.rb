module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class PluginManager
    def initialize
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
      Dir[File.join(PluginManager.plugin_path, "*", "help", "**", "*.md")]
    end
    
    def load_all
      load File.join(PluginManager.plugin_path, "plugins.rb")
      Plugins.all_plugins.each do |p|
        load_plugin p
      end
    end
    
    def load_plugin(name)
      plugin_loader = File.join(PluginManager.plugin_path, name, "#{name}.rb")
      Global.logger.info "Loading #{plugin_loader}"
      load plugin_loader
      module_name = find_plugin_const(name)
      if (!module_name)
        raise SystemNotFoundException
      end
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      Global.config_reader.load_plugin_config plugin_module.plugin_dir, plugin_module.config_files
      @plugins << plugin_module.send(:load_plugin)
    end
    
    def unload_plugin(name)
      Global.logger.info "Unloading #{plugin_loader}"
      mod = find_plugin_const(name)
      if (!mod)
        raise SystemNotFoundException
      end
      Global.config.delete name
      @plugins.delete Object.const_get("AresMUSH::#{mod}")
      AresMUSH.send(:remove_const, "AresMUSH::#{mod}")
    end
      
    private    
    
    def find_plugin_const(name)
      AresMUSH.constants.select { |c| c.upcase == name.to_sym.upcase }.first
    end    
  end
end