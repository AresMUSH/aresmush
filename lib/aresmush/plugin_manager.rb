require 'ansi'

module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class PluginManager
    def initialize(plugin_factory, game_dir)
      @plugins_path = File.join(game_dir, "plugins")
      @plugin_factory = plugin_factory
      @plugins = []
    end
    
    attr_reader :plugins
    
    def load_all
      plugin_files = Dir[File.join(@plugins_path, "*", "lib", "*.rb")]
      load_plugin_code(plugin_files)
      @plugins = @plugin_factory.create_plugin_classes
    end
    
    def load_plugin(name)
      plugin_files = Dir[File.join(@plugins_path, name, "lib", "*.rb")]
      raise SystemNotFoundException if plugin_files.empty?
      load_plugin_code(plugin_files)
      @plugins = @plugin_factory.create_plugin_classes
    end
      
    private    
    def load_plugin_code(files)
      files.each do |f| 
        logger.info "Loading #{f}."
        load f
      end
    end 
  end
end