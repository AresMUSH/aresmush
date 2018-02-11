module AresMUSH
  module Install
    def self.default_if_blank(current, default)
      current.blank? ? default : current
    end
    
    def self.error_if_blank(current, name)
      if (current.blank?)
        raise "#{name} may not be blank!"
      end
    end
    
    def self.configure_game
      template_path = File.join(File.dirname(__FILE__), 'templates')
    
      puts "\nLet's set up your database.  Please enter the requested information."

      print "Database url (default 127.0.0.1:6379)> "
      db_url = STDIN.gets.chomp
      db_url = default_if_blank(db_url, '127.0.0.1:6379')
      
      print "\nCreate a database password > "
      db_password = STDIN.gets.chomp
      error_if_blank(db_password, "DB Password")
      
      template_data =
      {
        "db_url" => db_url,
        "db_password" => db_password
      }
  
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'database.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'database.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'secrets.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'secrets.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
  
      puts "\nGreat.  Now we'll gather some server information.  See http://aresmush.com/tutorials/install/basic-config for help with these options."
  
      print "\nServer hostname (ex: yourmush.aresmush.com or an IP)> "
      server_host = STDIN.gets.chomp
      error_if_blank(server_host, "Hostname")

      print "\nServer telnet port (default 4201)> "
      server_port = STDIN.gets.chomp
      server_port = default_if_blank(server_port, '4201')

      print "\nServer web socket port (default 4202)> "
      websocket_port = STDIN.gets.chomp
      websocket_port = default_if_blank(websocket_port, '4202')
      
      print "\nServer engine API port (default 4203)> "      
      engine_api_port = STDIN.gets.chomp
      engine_api_port = default_if_blank(engine_api_port, '4203')

      print "\nServer website port (default 80)> "
      web_portal_port = STDIN.gets.chomp
      web_portal_port = default_if_blank(web_portal_port, '80')

      print "\nMUSH Name > "
      mush_name = STDIN.gets.chomp
      error_if_blank(mush_name, "MUSH Name")

      print "\nMUSH Description > "
      game_desc = STDIN.gets.chomp

      print "\nWebsite > "
      website = STDIN.gets.chomp
  
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
        "website" => website,
        "public_game" => false
      }
  
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'server.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'server.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'game.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'game.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
  
      puts "\nYour game has been configured!  You can edit these and other game options through the files in game/config."
      
    end
  end
end