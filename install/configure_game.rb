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
    
    def self.configure_game
      
      engine_api_key = SecureRandom.uuid
      
      template_path = File.join(File.dirname(__FILE__), 'templates')
      puts "\nYou can press 'enter' for any option to accept the default."
      puts "\nLet's set up your database.  The default options should suffice unless you've done something unusual with your Redis installation."

      db_url = get_optional_field "Database url", '127.0.0.1:6379'
      
      template_data =
      {
        "db_url" => db_url,
      }
  
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'database.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'database.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      if (File.exists?(File.join(AresMUSH.game_path, "config", "secrets.yml")))
        db_password = nil
      else
        db_password = ('a'..'z').to_a.shuffle[0,30].join
        template_data =
        {
          "engine_api_key" => engine_api_key,
          "db_password" => db_password
        }
        puts "\nYour database password has been set to #{db_password}.  This will be stored in the secrets.yml config file."
        
        template = Erubis::Eruby.new(File.read(File.join(template_path, 'secrets.yml.erb'), :encoding => "UTF-8"))
        File.open(File.join(AresMUSH.game_path, 'config', 'secrets.yml'), 'w') do |f|
          f.write(template.evaluate(template_data))
        end
      end
      
    
  
      puts "\nGreat.  Now we'll gather some server information.  See http://aresmush.com/tutorials/install/install-game for help with these options."
  
      server_host = get_required_field "Server hostname (ex: yourmush.aresmush.com or an IP)"
      server_port = get_optional_field "Server telnet port", "4201"
      websocket_port = get_optional_field "Server web socket port", "4202"
      engine_api_port = get_optional_field "Server engine API port", "4203"
      web_portal_port = get_optional_field "Server website port", "80"

      mush_name = get_required_field "MUSH Name"
      game_desc = get_required_field "Game Description"
      
      print "\nMUSH Category > "
      print "\nPick one:"
      print "\n[1] Social"
      print "\n[2] Historical"
      print "\n[3] Sci-Fi"
      print "\n[4] Fantasy"
      print "\n[5] Modern"
      print "\n[6] Supernatural"
      print "\n[7] Other"
      print "\n Select a Category > "
      input = STDIN.gets.chomp

      case input
      when "1"
        category = "Social"
      when "2"
        category = "Historical"
      when "3"
        category = "Sci-Fi"
      when "4" 
        category = "Fantasy"
      when "5"
        category = "Modern"
      when "6"
        category = "Supernatural"
      else
        category = "Other"
      end
  
      template_data = 
      {
        "host_name" => server_host,
        "host_port" => server_port,
        "websocket_port" => websocket_port,
        "web_portal_port" => web_portal_port,
        "engine_api_port" => engine_api_port,
        "mush_name" => mush_name,
        "category" => category,
        "game_desc" => game_desc,
        "website" => '',
        "public_game" => false,
        "game_status" => 'In Development'
      }
  
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
      
      print "\nNext we'll set up some information that will be used when you interact with the version control system GitHub for code updates."
      
      git_email = get_optional_field "GitHub Email", "admin@#{server_host}"
      git_name = get_optional_field "GitHub Name", "#{mush_name} Admin"
      
      if (!git_email.blank?)
        `git config --global user.email "#{git_email}"`
      end
      
      if (!git_name.blank?)
        `git config --global user.name "#{git_name}"`
      end
      
      begin
        webportal_dir = DatabaseMigrator.read_config_file("website.yml")['website']['website_code_path']
        if (webportal_dir && Dir.exist?(webportal_dir))
          if (web_portal_port.to_s == '80')
            port_str = ""
          else
            port_str = ":#{web_portal_port}"
          end
        
          File.open(File.join(webportal_dir, "public", "robots.txt"), "a") do |f| 
            f.write("\nSitemap: #{server_host}#{port_str}/game/sitemap.xml")
          end
        else
          raise "Directory doesn't exist."
        end
      rescue Exception => ex
        puts "!!!!!!!"
        puts "Your Ares web portal directory can't be found, or there's a problem accessing it."
        puts "In order to set up your search engine, you'll need to manually edit the robots file."
        puts "See https://aresmush.com/tutorials/config/website/ for details."
        puts "!!!!!!!"
      end
     
      puts "\nYour game has been configured!  You can edit these and other game options through the files in game/config."
      
    end
  end
end