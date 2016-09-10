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
      config = Dir[File.join(PluginManager.plugin_path, "**", "config*.yml")]
      config.concat Dir[File.join(PluginManager.plugin_path, "**", "shortcut*.yml")]
    end
    
    def self.help_files
      Dir[File.join(PluginManager.plugin_path, "*", "help", "**", "*.md")]
    end
    
    def self.plugin_files(name = nil)
      if (name.nil?)
        path = File.join(PluginManager.plugin_path, "**", "*.rb")
      else
        path = File.join(PluginManager.plugin_path, name, "**", "*.rb")
      end
      
      all_files = Dir[path]
      all_files.select { |f| f !~ /_(spec|test|test_loader)[s]*\.rb*/ }
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
      plugin_module_name = name.upcase
      plugins_to_delete = []
      module_to_delete = nil
      @plugins.each do |p|
        if (p.class.name.upcase.starts_with?("ARESMUSH::#{plugin_module_name}::"))
          plugins_to_delete << p
          module_to_delete = p.class.name.after("AresMUSH::").first("::")
        end
      end

      if plugins_to_delete.empty?
        raise SystemNotFoundException
      end

      if (module_to_delete)
        if (AresMUSH.const_defined?(module_to_delete))
          Global.logger.debug "Deleting #{module_to_delete}."
          AresMUSH.send(:remove_const, module_to_delete)
        else
          raise SystemNotFoundException
        end
      end

      plugins_to_delete.each do |p|
        @plugins.delete(p)
        Global.logger.info "Unloading #{p}."
      end
    end
      
    private    
    def load_plugin_code(files)
      files.sort.each do |f| 
        Global.logger.info "Loading #{f}."
        load f
      end
      @plugins = @plugin_factory.create_plugin_classes
    end 
  end
end