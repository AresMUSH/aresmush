module AresMUSH
  module Manage
    class PluginImporter
      def initialize(plugin_name)
        @tmp_dir = "/tmp/ares-extras"
        @plugin_name = plugin_name
        @source_dir = File.join(@tmp_dir, @plugin_name)
      end
        
      def import
        
        #if (Dir.exist?(@tmp_dir))
        #  FileUtils.rm_rf @tmp_dir
        # end
        #`git clone https://github.com/AresMUSH/ares-extras.git /tmp/ares-extras`
  
  
        if (!Dir.exist?(@source_dir))
          puts "ERROR! Directory #{@source_dir} not found."
          return
        end
  
        import_plugin
        import_game
        import_portal
        
        puts "Plugin #{@plugin_name} added."
      end
      
      def import_plugin
        
        plugin_dir = File.join(@source_dir, "plugin")
        dest_path = File.join(AresMUSH.root_path, "plugins", @plugin_name)  
        
        if (!Dir.exist?(plugin_dir))
          return
        end
        
        if (!Dir.exist?(dest_path))
          Dir.mkdir dest_path
        end
        
        if (!File.exists?(File.join(plugin_dir, "#{@plugin_name}.rb")))
          puts "ERROR! Plugin module file #{@plugin_name}.rb not found."
          return
        end
        
        puts "Copying plugin files to #{dest_path}."  
        plugin_files = Dir["#{plugin_dir}/*"]
        plugin_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
      
      def import_game
  
        game_dir = File.join(@source_dir, "game")
        dest_path = AresMUSH.game_path
        
        if (!Dir.exist?(game_dir))
          return
        end
        
        puts "Copying game files to #{dest_path}."  
        game_files = Dir["#{game_dir}/*"]
        game_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
      
      def import_portal
        web_source_dir = File.join(@source_dir, "webportal")
        dest_path = File.join( Global.read_config("website", "website_code_path"), "app" )

        if (!Dir.exist?(web_source_dir))
          return
        end
        
        if (!Dir.exist?(dest_path))
          puts "WARNING! Web Portal directory #{dest_path} not found.  You'll need to install web files manually." 
          return
        end
        
        puts "Copying web portal files to #{dest_path}."
        
        web_files = Dir["#{web_source_dir}/*"]
        web_files.each do |f|
          FileUtils.cp_r(f, dest_path)
        end
      end
    end
  end
end