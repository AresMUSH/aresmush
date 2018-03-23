module AresMUSH
  module Manage
    module PluginImporter
      def self.import(plugin_name)
        tmp_dir = "/tmp/ares-extras"
        #if (Dir.exist?(tmp_dir))
        #  FileUtils.rm_rf tmp_dir
        # end
        #`git clone https://github.com/AresMUSH/ares-extras.git /tmp/ares-extras`
  
        source_dir = File.join(tmp_dir, plugin_name)
  
        if (!Dir.exist?(source_dir))
          puts "ERROR! Directory #{source_dir} not found."
          return
        end
  
        if (!File.exists?(File.join(source_dir, "#{plugin_name}.rb")))
          puts "ERROR! Plugin module file #{plugin_name}.rb not found."
          return
        end
  
        plugins_path = File.join(AresMUSH.root_path, "plugins")  
        puts "Copying game engine files to #{plugins_path}"
        FileUtils.cp_r(source_dir, plugins_path)
  
        config_files = Dir["#{File.join(plugins_path, plugin_name)}/*.yml"]
        config_files.each do |c|
          dest_path = File.join(AresMUSH.game_path, "config", File.basename(c))
          puts "Copying config file #{c} to #{dest_path}."
          FileUtils.mv(c, dest_path)
        end
  
        web_source_dir = File.join(AresMUSH.root_path, "plugins", plugin_name, "webportal")
        if (Dir.exist?(web_source_dir))
          webportal_path = Global.read_config("website", "website_code_path")
          if (Dir.exist?(webportal_path))
            web_dirs = Dir["#{web_source_dir}/*"].select { |d| File.directory?(d) }
            web_dirs.each do |d|
              dest_dir = File.join(webportal_path, "app")
              puts "Copying #{File.basename(d)} to #{dest_dir}."
              FileUtils.cp_r(d, dest_dir)
              FileUtils.remove_dir(d)
            end
            
            router_source_path = File.join(web_source_dir, "router.js")
            router_dest_path = File.join(webportal_path, "app", "router.js")
            puts "#{router_source_path} #{router_dest_path}"
            if (File.exists?(router_source_path))
              puts "Adding web portal routes."
              new_routes = File.read(router_source_path)
              old_routes = File.read(router_dest_path)
              if (old_routes =~ /\/\/ \+\!/)
                File.open(router_dest_path, 'w') do |f|
                  f.write old_routes.gsub("// +!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", "#{new_routes}\n  // +!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                end
                
              else
                puts "WARNING! Could not install web portal routes.  You'll need to do it manually."
              end
            end
              
          else
            puts "WARNING! Web Portal directory #{webportal_path} not found.  You'll need to install web files manually."            
          end
        end
          
        
        
        puts "Plugin #{plugin_name} added."
      end
    end
  end
end