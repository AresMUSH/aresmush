module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class PluginManager
    def initialize
      @plugins = []
    end
    
    attr_reader :plugins
      
    def all_plugin_folders
      Dir[File.join(AresMUSH.plugin_path, '*')]
         .select { |f| File.directory?(f) }
        .map{ |f| File.basename(f) }
    end 
     
    def load_all
      self.all_plugin_folders.sort_by { |p| p == 'custom' ? 'zzzzzzzcustom' : p }.each do |p|
        load_plugin p
      end
    end
    
    def is_disabled?(name)
      disabled_plugins = Global.read_config('plugins', 'disabled_plugins').map { |p| p.downcase }
      disabled_plugins.include?(name.downcase)
    end
    
    def load_plugin(name)
      Global.logger.info "Loading #{name}"

      plugin_path = File.join(AresMUSH.plugin_path, name)
      plugin_file = File.join(plugin_path, "#{name}.rb")
      if (File.exists?(plugin_file))
        load plugin_file
      else
        Global.logger.debug "Plugin loader file #{name} does not exist."
      end
      
      load_file = File.join(plugin_path, "_load.rb")
      if (File.exists?(load_file))
        load load_file
      else
        code_files(plugin_path).each do |f|
          load f
        end
      end
      
      if (is_disabled?(name))
        return
      end
      
      module_name = find_plugin_const(name)
      if (!module_name)
        raise SystemNotFoundException.new("Can't find a module for #{name}.")
      end
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      load_plugin_locale plugin_module
      load_plugin_help plugin_module
                  
      if (plugin_module.respond_to?(:init_plugin))
        plugin_module.send(:init_plugin)
      end
      @plugins << plugin_module
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
    
    def code_files(path)
      files = []
      skip_dirs = [ 'spec', 'specs' ]
      dirs = Dir[File.join(path, '*')].select{ |f| File.directory?(f) }.select { |f| !skip_dirs.include?(File.basename(f))}
      
      files = files.concat(Dir[File.join(path, "*.rb")])
      dirs.each do |d| 
        files = files.concat(Dir[File.join(d, '**', "*.rb")])
      end

      files
    end

    def load_plugin_help_by_name(name)
      module_name = find_plugin_const(name)
      return if (!module_name)
      plugin_module = Object.const_get("AresMUSH::#{module_name}")
      load_plugin_help plugin_module
    end
    
    def load_plugin_help(plugin_module)
      plugin_name = plugin_module.to_s.after("::")
      
      if (is_disabled?(plugin_name))
        return
      end
      
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
          if (p.shortcuts)
            sc.merge! p.shortcuts
          end
        rescue Exception => ex
          Global.logger.error "Error parsing shortcuts: #{p} #{ex}"
        end
      end
      sc
    end
    
    def achievements
      achieve = {}
      plugins.each do |p|
        begin
          next if !p.respond_to?(:achievements)
          if (p.achievements)
            achieve.merge! p.achievements
          end
        rescue Exception => ex
          Global.logger.error "Error parsing achievements: #{p} #{ex}"
        end
      end
      achieve
    end
    
    def check_plugin_config
      errors = []
      plugins.each do |p|
        begin
          next if !p.respond_to?(:check_config)
          errors.concat p.check_config
        rescue Exception => ex
          errors << "Error checking config: #{p} #{ex}"
        end
      end
      errors
    end
    
    def sorted_plugins
      self.plugins.sort_by { |p| [ p.name == "AresMUSH::Custom" ? 0 : 1, p.name ]}
    end
    
    private    
    
    def find_plugin_const(name)
      AresMUSH.constants.select { |c| c.upcase == name.to_sym.upcase }.first
    end    
  end
end