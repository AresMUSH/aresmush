require 'ansi'

module AresMUSH
  
  class SystemNotFoundException < Exception
  end
  
  class AddonManager
    def initialize(addon_factory, game_dir)
      @addons_path = File.join(game_dir, "addons")
      @addon_factory = addon_factory
      @addons = []
    end
    
    attr_reader :addons

    def load_all
      addon_files = Dir[File.join(@addons_path, "**", "*.rb")]
      load_addon_code(addon_files)
      @addons = @addon_factory.create_addon_classes
    end
    
    def load_addon(name)
      addon_files = Dir[File.join(@addons_path, name, "**", "*.rb")]
      raise SystemNotFoundException if addon_files.empty?
      load_addon_code(addon_files)
      @addons = @addon_factory.create_addon_classes
    end
      
    private    
    def load_addon_code(files)
      files.each do |f| 
        logger.info "Loading #{f}."
        load f
      end
    end 
  end
end