module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class PluginManager
    def initialize
      @plugins = []
    end
    
    attr_reader :plugins
        
    def load_all(web_or_engine)
      load File.join(AresMUSH.plugin_path, "plugins.rb")
      Plugins.all_plugins.each do |p|
        load_plugin p, web_or_engine
      end
    end
    
    def load_plugin(name, web_or_engine)
      Global.logger.info "Loading #{name} for #{web_or_engine}"

      plugin_file = File.join(AresMUSH.plugin_path, name, "#{name}.rb")
      if (File.exists?(plugin_file))
        load plugin_file
      else
        Global.logger.debug "Plugin loader file #{name} does not exist."
      end
      
      library_file = File.join(AresMUSH.plugin_path, name, "lib", "_load.rb")
      if (File.exists?(library_file))
        load library_file
      else
        Global.logger.debug "Plugin library file for #{name} does not exist."
      end
      
      target_file = File.join(AresMUSH.plugin_path, name, web_or_engine.to_s, "_load.rb")
      if (File.exists?(target_file))
        load target_file
      else
        Global.logger.debug "Plugin web file for #{name} does not exist."
      end
      
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
      config_files(plugin_module).each do |config|
        puts config
        Global.config_reader.load_config_file config
      end
      
      # Force the website to restart next time
      FileUtils.touch(File.join(AresMUSH.root_path, "tmp", "restart.txt"))
    end
    
    def validate_plugin_config(plugin_module)
      config_files(plugin_module).each do |config|
        Global.config_reader.validate_config_file config
      end
    end
    
    def load_plugin_locale(plugin_module)
      Global.locale.locale_order.each do |locale|
        file = File.join(plugin_module.plugin_dir, "locales", "locale_#{locale}.yml")
        if File.exists?(file)
          Global.locale.add_locale_file file
        end
      end
    end

    def config_files(plugin_module)
      search = File.join(plugin_module.plugin_dir, "config_**.yml")
      Dir[search]
    end

        
    def help_files(plugin_module, locale)
      search = File.join(plugin_module.plugin_dir, "help", locale, "**.md")
      Dir[search]
    end

    def load_plugin_help_by_name(name)
      module_name = find_plugin_const(name)
      return if (!module_name)
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      load_plugin_help plugin_module
    end
    
    def load_plugin_help(plugin_module)
      plugin_name = plugin_module.to_s.after("::")
      Global.locale.locale_order.each do |locale|
        help_files = self.help_files(plugin_module, locale)
        help_files.each do |path|              
          Global.help_reader.load_help_file path, plugin_name
        end
      end
    end
    
    def unload_plugin(name)
      Global.logger.info "Unloading #{name}"
      
      module_name = find_plugin_const(name)
      if (!module_name)
        raise SystemNotFoundException
      end

      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      if (!plugins.include?(plugin_module))
        raise SystemNotFoundException
      end

      Global.config_reader.config.delete name
      Global.help_reader.unload_help(name.downcase)
      @plugins.delete plugin_module
      AresMUSH.send(:remove_const, module_name)
    end
      
      
    def shortcuts
      sc = {}
      plugins.each do |p|
        begin
          plugin_shortcuts = p.shortcuts
          if (p.shortcuts)
            sc.merge! p.shortcuts
          end
        rescue Exception => ex
          Global.logger.error "Error parsing shortcuts: #{p} #{ex}"
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