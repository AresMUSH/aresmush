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
    
    def load_all
      load File.join(PluginManager.plugin_path, "plugins.rb")
      Plugins.all_plugins.each do |p|
        load_plugin p
      end
    end
    
    def load_plugin(name)
      Global.logger.info "Loading #{name}"
      plugin_loader = File.join(PluginManager.plugin_path, name, "#{name}.rb")
      load plugin_loader
      module_name = find_plugin_const(name)
      if (!module_name)
        raise SystemNotFoundException.new("Can't find a module for #{name}.")
      end
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      load_plugin_config plugin_module
      load_plugin_locale plugin_module
      load_plugin_help plugin_module
      
      @plugins << plugin_module.send(:load_plugin)
    end
    
    def load_plugin_config(plugin_module)
      plugin_module.config_files.each do |config|
        Global.config_reader.load_config_file File.join(plugin_module.plugin_dir, config)
      end
    end
    
    def validate_plugin_config(plugin_module)
      plugin_module.config_files.each do |config|
        Global.config_reader.validate_config_file File.join(plugin_module.plugin_dir, config)
      end
    end
    
    def load_plugin_locale(plugin_module)
      plugin_module.locale_files.each do |locale|   
        Global.locale.add_locale_file File.join(plugin_module.plugin_dir, locale)
      end
    end
    
    def load_plugin_help(plugin_module)
      plugin_module.help_files.each do |help|              
        Global.help_reader.load_help_file File.join(plugin_module.plugin_dir, help)
      end
    end
    
    def unload_plugin(name)
      Global.logger.info "Unloading #{name}"
      module_name = find_plugin_const(name)
      if (!module_name)
        raise SystemNotFoundException
      end
      Global.config_reader.config.delete name
      Global.help_reader.unload_help(name.downcase)
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      @plugins.delete plugin_module
      AresMUSH.send(:remove_const, module_name)
    end
      
      
    def shortcuts
      sc = {}
      plugins.each do |p|
        plugin_shortcuts = p.shortcuts
        if (p.shortcuts)
          sc.merge! p.shortcuts
        end
      end
      sc
    end
    
    private    
    
    def find_plugin_const(name)
      AresMUSH.constants.select { |c| c.upcase == name.to_sym.upcase }.first
    end    
  end
end