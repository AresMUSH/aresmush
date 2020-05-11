module AresMUSH
  module Install
    
    def self.get_required_field(prompt)
      print "\n#{prompt} > "
      input = STDIN.gets.chomp
      while (input.blank?)
        puts "\nERROR: Value required!"
        print "\n#{prompt} > "
        input = STDIN.gets.chomp
      end
      input
    end
    
    def self.get_optional_field(prompt, default = nil)
      print "\n#{prompt} (default #{default || 'none' }) > "
      
      input = STDIN.gets.chomp
      if (input.blank?)
        input = default || ""
      end
      input
    end
    
    def self.configure_game(options)
      
      template_path = File.join(File.dirname(__FILE__), 'templates')
      
      if (!options.blank?)
        template_data = self.parse_options(options)
      else        
        template_data = self.ask_for_options
      end
  
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'database.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'database.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      engine_api_key = SecureRandom.uuid
      if (File.exists?(File.join(AresMUSH.game_path, "config", "secrets.yml")))
        db_password = nil
      else
        db_password = ('a'..'z').to_a.shuffle[0,30].join
        secrets_data =
        {
          "engine_api_key" => engine_api_key,
          "db_password" => db_password
        }
        
        template = Erubis::Eruby.new(File.read(File.join(template_path, 'secrets.yml.erb'), :encoding => "UTF-8"))
        File.open(File.join(AresMUSH.game_path, 'config', 'secrets.yml'), 'w') do |f|
          f.write(template.evaluate(secrets_data))
        end
      end
        
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'server.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'server.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'game.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'game.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'nginx.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.root_path, 'install', 'nginx.default'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      `git config --global user.email "admin@#{template_data['host_name']}"`
      `git config --global user.name "Admin"`
      
      begin
        web_portal_port = template_data['web_portal_port']
        webportal_dir = DatabaseMigrator.read_config_file("website.yml")['website']['website_code_path']
        if (webportal_dir && Dir.exist?(webportal_dir))
          if (web_portal_port.to_s == '80')
            port_str = ""
          else
            port_str = ":#{web_portal_port}"
          end
        
          File.open(File.join(webportal_dir, "public", "robots.txt"), "a") do |f| 
            f.write("\nSitemap: #{template_data['server_host']}#{port_str}/game/sitemap.xml")
          end
        else
          raise "Directory doesn't exist."
        end
      rescue Exception => ex
        puts "!!!!!!!"
        puts "Your Ares web portal directory can't be found, or there's a problem accessing it."
        puts "!!!!!!!"
      end
     
      puts "\nYour game has been configured!  You can edit these and other game options through the files in game/config."
    end
    
    def self.parse_options(options)
      opts_list = options.split("~")
      opts_data = {}
      opts_list.each do |opt|
        key = opt.split("=")[0]
        val = opt.split("=")[1]
        opts_data[key] = val
      end
      
      puts "Configuring with options: #{options}."
      
      host_port = opts_data['server_port'] || '4201'
      
      {
        "host_name" => opts_data['host_name'] || 'localhost',
        "host_port" => host_port,
        "websocket_port" => (host_port.to_i + 1).to_s,
        "engine_api_port" => (host_port.to_i + 2).to_s,
        "web_portal_port" => '80',
        "mush_name" => opts_data['mush_name'] || "Test Game",
        "category" => "Other",
        "game_desc" => "Coming Soon",
        "website" => '',
        "public_game" => false,
        "game_status" => 'In Development',
        "db_url" => "127.0.0.1:6379"
      }
    end
    
    def self.ask_for_options
      
      puts "\nYou can press 'enter' for any option to accept the default."

      puts "\nGive your MUSH a name.  You can change your game name, description and category later in the web portal configuration screen."
      mush_name = get_required_field "MUSH Name"      

      puts "\nGreat.  Now we need to know the hostname, like yourmush.aresmush.com. You can use the server's IP address if you don't have a domain name."
      server_host = get_required_field "Server hostname (ex: yourmush.aresmush.com or an IP)"
      
      puts "\nNow you can choose the port that people will connect to from a MUSH client.  See https://aresmush.com/tutorials/install/install-game.html#ports for help."
      
      server_port = get_optional_field "Server telnet port", "4201"

      puts "\nAres also uses other ports for the web portal, web-game communication, and database.  You can accept the default values for typical systems.  See https://aresmush.com/tutorials/install/install-game.html#ports for help."

      websocket_port = get_optional_field "Server web socket port", "4202"
      engine_api_port = get_optional_field "Server engine API port", "4203"
      web_portal_port = get_optional_field "Server website port", "80"
      db_url = get_optional_field "Database url", '127.0.0.1:6379'

            
      {
        "host_name" => server_host,
        "host_port" => server_port,
        "websocket_port" => websocket_port,
        "engine_api_port" => engine_api_port,
        "web_portal_port" => web_portal_port,
        "mush_name" => mush_name,
        "category" => "Other",
        "game_desc" => "Coming Soon",
        "website" => '',
        "public_game" => false,
        "game_status" => 'In Development',
        "db_url" => db_url
      }
    end
    
  end
end