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
    
    def load_plugin(name)
      plugin_files = PluginManager.plugin_files(name)
      raise SystemNotFoundException if plugin_files.empty?
      load_plugin_code(plugin_files)
    end
    
    def unload_plugin(name)
      plugin_module_name = name.titlecase
      plugins_to_delete = []
      @plugins.each do |p|
        if (p.class.name.starts_with?("AresMUSH::#{plugin_module_name}::"))
          plugins_to_delete << p
        end
      end

      if plugins_to_delete.empty?
        raise SystemNotFoundException
      end
      
      if (AresMUSH.const_defined?(plugin_module_name))
        Global.logger.debug "Deleting #{plugin_module_name}."
        AresMUSH.send(:remove_const, plugin_module_name)
      else
        raise SystemNotFoundException
      end

      plugins_to_delete.each do |p|
        @plugins.delete(p)
        Global.logger.info "Unloading #{p}."
      end
    end
      
    private    
    def load_plugin_code(files)
      files.each do |f| 
        Global.logger.info "Loading #{f}."
        load f
      end
      @plugins = @plugin_factory.create_plugin_classes
    end 
  end
end