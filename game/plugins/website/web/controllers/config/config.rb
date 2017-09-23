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
      @game_config = ConfigReader.config_files.map { |f| f.gsub(game_path, "") }
      @game_help = Dir[File.join(game_path, "help", "**", "*.md")].map { |f| f.gsub(game_path, "") }
      @plugin_config = {}
      Global.plugin_manager.plugins.each do |p|
        plugin_name = p.to_s.after('::').downcase
        
        @plugin_config[plugin_name] = {}
        help_files = Dir[File.join(game_path, "plugins", plugin_name, "help", "**", "*.md")]
        @plugin_config[plugin_name]["help"] = help_files.map { |f| f.gsub(game_path, "") }


        locale_files = Dir[File.join(game_path, "plugins", plugin_name, "locales", "*.yml")]
        @plugin_config[plugin_name]["locale"] = locale_files.map { |f| f.gsub(game_path, "") }
        
        @plugin_config[plugin_name]["config"] = p.config_files.map { |f| File.join("plugins", plugin_name, f) }
        
        template_files = Dir[File.join(game_path, "plugins", plugin_name, "templates", "**", "*")]
        @plugin_config[plugin_name]["templates"] = template_files.map { |f| f.gsub(game_path, "") }
        
        
      end
      
      template_files = Dir[File.join(game_path, "plugins", 'website', "web", "views", "**", "*")]
      @plugin_config['website']["templates"] = template_files
          .select { |f| !File.directory?(f) }
          .map { |f| f.gsub(game_path, "") }
          .sort
      
      
      erb :"admin/config_index"
    end

  end
end
