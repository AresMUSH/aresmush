module AresMUSH
  module Manage
    class PluginImporter
      def initialize(github_url)
        @tmp_dir = "/tmp/ares-extras"
        @github_url = github_url
        @repo_name = (github_url || "").split("/").last.downcase.gsub(".git", "")
        @source_dir = File.join(@tmp_dir, @repo_name)
      end
      
      def plugin_name
        # Same as the 'keyname' property in AresCentral
        @repo_name.after("-").before("-")
      end
      
      def import

        if (@repo_name !~ /^ares-[\w\d]+-plugin$/)
          raise "ERROR! Plugin not compatible with installer. Repo name invalid."
        end
        
        if (Dir.exist?(@tmp_dir))
          FileUtils.rm_rf @tmp_dir
         end
        `git clone #{@github_url} #{@source_dir}`
  
  
        if (!Dir.exist?(@source_dir))
          raise "ERROR! Directory #{@source_dir} not found."
        end
        
        existing = import_plugin
        if (existing)
          Global.logger.info "Plugin previously installed - skipping game directory."
          Global.logger.info "If want to overwrite your configuration, you'll have to copy the game/config files manually from #{@source_dir} to your aresmush/game directory."
        else
          import_game
        end
        import_portal
        update_extras
        
        Global.logger.info "Plugin #{self.plugin_name} added."
      end
      
      def import_plugin
        
        plugin_dir = File.join(@source_dir, "plugin")
        dest_path = File.join(AresMUSH.root_path, "plugins", self.plugin_name)  
        exists = Dir.exist?(dest_path)
        
        if (!Dir.exist?(plugin_dir))
          Global.logger.debug "No plugin files to import."
          return false
        end
        
        if (!File.exist?(File.join(plugin_dir, "#{self.plugin_name}.rb")))
          raise "ERROR! Plugin module file #{self.plugin_name}.rb not found.  This plugin can't be automatically imported."
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
          Global.logger.warn "WARNING! web portal directory #{dest_path} not found.  You'll need to install web files manually." 
          return
        end
        
        Global.logger.debug "Copying web portal files to #{dest_path}."
        
        web_files = Dir["#{web_source_dir}/*"]
        web_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
      
      def update_extras
        Manage.add_extra_plugin_to_config(self.plugin_name)
      end
    end
  end
end