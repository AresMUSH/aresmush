module AresMUSH
  module Install
    def self.init_db
      Mongoid.purge!
  
      AresMUSH::ObjectModel.models.each do |m|
        puts "Clearing out #{m}"
        #m.delete_all
        #m.remove_indexes
        m.create_indexes
      end

      game = AresMUSH::Game.create

      puts "Creating start rooms."
  
      welcome_room = AresMUSH::Room.create(:name => "Welcome Room", :room_type => "OOC")
      ic_start_room = AresMUSH::Room.create(:name => "IC Start", :room_type => "IC")
      ooc_room = AresMUSH::Room.create(:name => "OOC Center", :room_type => "OOC")
  
      game.welcome_room = welcome_room
      game.ic_start_room = ic_start_room
      game.ooc_room = ooc_room
      game.save!
  
      puts "Creating OOC chars."
      
      headwiz = AresMUSH::Character.new(name: "Headwiz")
      headwiz.change_password("change_me!")
      headwiz.roles << "admin"
      headwiz.save!
  
      builder = AresMUSH::Character.new(name: "Builder")
      builder.change_password("change_me!")
      builder.roles << "builder"
      builder.save!
  
      systemchar = AresMUSH::Character.new(name: "System")
      systemchar.change_password("change_me!")
      systemchar.roles << "admin"
      systemchar.save!

      4.times do |n|
        guest = AresMUSH::Character.new(name: "Guest-#{n+1}")
        guest.change_password("guest")
        guest.roles << "guest"
        guest.save!
      end

      game.master_admin = headwiz
      game.system_character = systemchar
      game.save!
  
      puts "Creating server info."
  
      AresMUSH::ServerInfo.create(
      game_id: AresMUSH::ServerInfo.arescentral_game_id,
      name: "AresCentral", 
      description: "Central hub for all things AresMUSH-related.", 
      host: "mush.aresmush.com",
      port: 7206)
    
      puts "Creating channels and BBS."
  
      AresMUSH::BbsBoard.create(name: "Announcements", order: 1)
      AresMUSH::BbsBoard.create(name: "Admin", order: 2, read_roles: [ "admin"], write_roles: [ "admin" ])
  
      AresMUSH::Channel.create(name: "Chat", announce: false, description: "Public chit-chat.", color: "%xy")
      AresMUSH::Channel.create(name: "Questions", description: "Questions and answers.", color: "%xg")
      AresMUSH::Channel.create(name: "Admin", description: "Admin business.", roles: ["admin"], color: "%xr")
  
  
      puts "Install complete."
    end
  end
end