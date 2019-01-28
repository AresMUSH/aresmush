module AresMUSH
  module Manage
    class PluginImporter
      def initialize(plugin_name)
        @tmp_dir = "/tmp/ares-extras"
        @plugin_name = (plugin_name || "").downcase
        @source_dir = File.join(@tmp_dir, "plugins", @plugin_name)
      end
        
      def import
        
        if (Dir.exist?(@tmp_dir))
          FileUtils.rm_rf @tmp_dir
         end
        `git clone https://github.com/AresMUSH/ares-extras.git /tmp/ares-extras`
  
  
        if (!Dir.exist?(@source_dir))
          raise "ERROR! Directory #{@source_dir} not found."
        end
  
        existing = import_plugin
        if (existing)
          Global.logger.info "Plugin previously installed - skipping game directory."
          Global.logger.info "If want to overwrite your configuration, you'll have to copy the game files manually from #{@source_dir} to your aresmush/game directory."
        else
          import_game
        end
        import_portal
        
        Global.logger.info "Plugin #{@plugin_name} added."
      end
      
      def import_plugin
        
        plugin_dir = File.join(@source_dir, "plugin")
        dest_path = File.join(AresMUSH.root_path, "plugins", @plugin_name)  
        exists = Dir.exist?(dest_path)
        
        if (!Dir.exist?(plugin_dir))
          Global.logger.debug "No plugin files to import."
          return false
        end
        
        if (!File.exists?(File.join(plugin_dir, "#{@plugin_name}.rb")))
          raise "ERROR! Plugin module file #{@plugin_name}.rb not found.  This plugin can't be automatically imported."
          return false
        end
        
        if !exists
          Dir.mkdir dest_path
        end
        
        Global.logger.debug "Copying plugin files to #{dest_path}."  
        plugin_files = Dir["#{plugin_dir}/*"]
        plugin_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
        
        return exists
      end
      
      def import_game
  
        game_dir = File.join(@source_dir, "game")
        dest_path = AresMUSH.game_path
        
        if (!Dir.exist?(game_dir))
          Global.logger.debug "No game files to import."
          return
        end
        
        Global.logger.debug "Copying game files to #{dest_path}."  
        game_files = Dir["#{game_dir}/*"]
        
        game_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
      
      def import_portal
        web_source_dir = File.join(@source_dir, "webportal")
        dest_path = File.join( Global.read_config("website", "website_code_path"), "app" )

        if (!Dir.exist?(web_source_dir))
          Global.logger.debug "No web files to import."
          return
        end
        
        if (!Dir.exist?(dest_path))
          Global.logger.warn "WARNING! Web Portal directory #{dest_path} not found.  You'll need to install web files manually." 
          return
        end
        
        Global.logger.debug "Copying web portal files to #{dest_path}."
        
        web_files = Dir["#{web_source_dir}/*"]
        web_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
    end
  end
end