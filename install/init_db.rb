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
  
      welcome_room = AresMUSH::Room.create(:name => "Welcome Room", :room_type => "OOC",
      :description => "Welcome!%R%R" + 
          "New to MUSHing?  Type: %xctutorial/start new player%xn for an interactive tutorial.%R%R" +
          "New to Ares?  Type: %xctutorial/start ares for vets%xn for a quick intro geared towards veteran players")
      ic_start_room = AresMUSH::Room.create(:name => "IC Start", :room_type => "IC")
      ooc_room = AresMUSH::Room.create(:name => "Offstage", :room_type => "OOC",
        :description => "This is a backstage area where you can hang out when not RPing.")
      quiet_room = AresMUSH::Room.create(:name => "Quiet Room", :room_type => "OOC",
        :description => "This is a quiet retreat, usually for those who are AFK and don't want to be spammed by conversations while they're away. If you want to chit-chat, please take it outside.")
      rp_room_hub = AresMUSH::Room.create(:name => "RP Annex", :room_type => "OOC",
        :description => "RP Rooms can be used for backscenes, private scenes, or scenes taking place in areas of the grid that are not coded.")

      4.times do |n|
        rp_room = AresMUSH::Room.create(:name => "RP Room #{n+1}", :room_type => "OOC",
          :description => "The walls of the room shimmer. They are shapeless, malleable, waiting to be given form. With a little imagination, the room can become anything.")
        AresMUSH::Exit.create(:name => "#{n+1}", :source => rp_room_hub, :dest => rp_room)
        AresMUSH::Exit.create(:name => "O", :source => rp_room, :dest => rp_room_hub)
      end

      AresMUSH::Exit.create(:name => "RP", :source => ooc_room, :dest => rp_room_hub)
      AresMUSH::Exit.create(:name => "QR", :source => ooc_room, :dest => quiet_room)

      AresMUSH::Exit.create(:name => "O", :source => welcome_room, :dest => ooc_room)
      AresMUSH::Exit.create(:name => "O", :source => quiet_room, :dest => ooc_room)
      AresMUSH::Exit.create(:name => "O", :source => rp_room_hub, :dest => ooc_room)
      
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
      category: "Social",
      description: "Central hub for all things AresMUSH-related.", 
      host: "mush.aresmush.com",
      game_open: "yes",
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
