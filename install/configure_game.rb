module AresMUSH
  module Install
    def self.configure_game
      template_path = File.join(File.dirname(__FILE__), 'templates')
    
      puts "\nLet's set up your database.  Please enter the requested information."

      print "Database host > "
      db_host = STDIN.gets.chomp

      print "\nDatabase port > "
      db_port = STDIN.gets.chomp

      print "\nDatabase name > "
      db_name = STDIN.gets.chomp

      print "\nDatabase user > "
      db_user = STDIN.gets.chomp

      print "\nDatabase password > "
      db_password = STDIN.gets.chomp
  
      template_data =
      {
        "db_host" => db_host,
        "db_port" => db_port,
        "db_name" => db_name,
        "db_user" => db_user,
        "db_password" => db_password
      }
  
      template = Erubis::Eruby.new(File.read(File.join(template_path, 'database.yml.erb'), :encoding => "UTF-8"))
      File.open(File.join(AresMUSH.game_path, 'config', 'database.yml'), 'w') do |f|
        f.write(template.evaluate(template_data))
      end
  
      puts "\nYour database is configured.  Now we'll set up your server information."
  
      print "\nServer hostname > "
      server_host = STDIN.gets.chomp

      print "\nServer port > "
      server_port = STDIN.gets.chomp

      print "\nMUSH Name > "
      mush_name = STDIN.gets.chomp

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
        "mush_name" => mush_name,
        "category" => category,
        "game_desc" => game_desc,
        "website" => website
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