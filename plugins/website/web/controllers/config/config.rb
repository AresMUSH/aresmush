module AresMUSH
  class WebApp
    helpers do

      def write_config_file(path, config)
        File.open(path, 'w') do |f|
          f.write(config)
        end
      end
      
    end
    
    get '/admin/config/?', :auth => :admin do
      game_path = AresMUSH.game_path
      plugin_path = AresMUSH.plugin_path
      root_path = AresMUSH.root_path

      @game_config = ConfigReader.config_files.map { |f| f.gsub(root_path, "") }
      @game_help = Dir[File.join(game_path, "help", "**", "*.md")].map { |f| f.gsub(root_path, "") }
      @plugin_config = {}
      Global.plugin_manager.plugins.each do |p|
        plugin_name = p.to_s.after('::').downcase
        
        @plugin_config[plugin_name] = {}
        help_files = Dir[File.join(plugin_path, plugin_name, "help", "**", "*.md")]
        @plugin_config[plugin_name]["help"] = help_files.map { |f| f.gsub(root_path, "") }


        locale_files = Dir[File.join(plugin_path, plugin_name, "locales", "*.yml")]
        @plugin_config[plugin_name]["locale"] = locale_files.map { |f| f.gsub(root_path, "") }
        
        @plugin_config[plugin_name]["config"] = Global.plugin_manager.config_files(p).map { |f| File.join("plugins", plugin_name, f) }
        
        template_files = Dir[File.join(plugin_path, plugin_name, "engine", "templates", "**", "*")]
        @plugin_config[plugin_name]["templates"] = template_files.map { |f| f.gsub(root_path, "") }

        view_files = Dir[File.join(plugin_path, plugin_name, "web", "views", "**", "*")].select { |f| !File.directory?(f) }
        @plugin_config[plugin_name]["views"] = view_files.map { |f| f.gsub(root_path, "") }
        
      end
      
      
      erb :"admin/config_index"
    end

  end
end
