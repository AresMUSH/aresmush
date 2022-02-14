module AresMUSH
  module Install
    def self.init_db

      password = Global.read_config("secrets", "database", "password")
      host = Global.read_config("database", "url")

      begin
        Ohm.redis.call "FLUSHDB"
      rescue
        Ohm.redis = Redic.new("redis://#{host}")
        puts Ohm.redis.call "config", "get", "requirepass"
        puts Ohm.redis.call "FLUSHDB"
        puts Ohm.redis.call "CONFIG", "SET", "requirepass", password
        Ohm.redis = Redic.new("redis://:#{password}@#{host}")
        puts Ohm.redis.call "CONFIG", "REWRITE"
      end
      game = Game.create

      puts "Creating start rooms."
  
      offstage = Area.create(name: "Offstage")
      
      welcome_room = Room.create(
        :name => "Welcome Room", 
        :room_type => "OOC", 
        :area => offstage,
        :description => "Welcome!%R%R" + 
        "New to MUSHing?  Visit http://aresmush.com/mush-101/ for an interactive tutorial.%R%R" +
        "New to Ares?  http://aresmush.com/tutorials/play/ares-for-vets.html for a quick intro geared towards veteran players.%R%R" +
        "You may need to configure your MU Client to take full advantage of Ares' features.  See https://aresmush.com/clients.html for details.%R%R" +
        "Type %xcchannels%xn for a list of available chat channels and the commands to speak on them.")

      ic_start_room = Room.create(
        :name => "Onstage", 
        :description => "This is the room where all characters start out.")
      
      ooc_room = Room.create(
        :name => "Offstage", 
        :room_type => "OOC", 
        :area => offstage,
        :description => "This is a backstage area where you can hang out when not RPing.")

      quiet_room = Room.create(
        :name => "Quiet Room", 
        :room_type => "OOC", 
        :area => offstage,
        :description => "This is a quiet retreat, usually for those who are AFK and don't want to be spammed by conversations while they're away. If you want to chit-chat, please take it outside.")
        
      rp_room_hub = Room.create(
        :name => "RP Annex", 
        :room_type => "OOC", 
        :area => offstage,
        :room_is_foyer => true,
        :description => "This game does not have RP/TP Rooms, but you can accomplish the same thing with the scenes system.  See %xchelp scenes%xn.")

      Exit.create(:name => "RP", :source => ooc_room, :dest => rp_room_hub)
      Exit.create(:name => "QR", :source => ooc_room, :dest => quiet_room)

      Exit.create(:name => "O", :source => welcome_room, :dest => ooc_room)
      Exit.create(:name => "O", :source => quiet_room, :dest => ooc_room)
      Exit.create(:name => "O", :source => rp_room_hub, :dest => ooc_room)
      
      game.welcome_room = welcome_room
      game.ic_start_room = ic_start_room
      game.ooc_room = ooc_room
      game.quiet_room = quiet_room
      game.save
  
      admin_role = Role.create(name: "admin", is_restricted: true)
      everyone_role = Role.create(name: "everyone")
      everyone_role.update(permissions: ["login"])
      builder_role = Role.create(name: "builder")
      builder_role.update(permissions: ["build", "teleport", "desc_places", "access_jobs" ] )
      guest_role = Role.create(name: "guest")
      approved_role = Role.create(name: "approved")
      approved_role.update(permissions: ["go_home", "boot", "announce"] )
      coder_role = Role.create(name: "coder", is_restricted: true)
      coder_role.update(permissions: ["manage_game", "access_jobs", "tinker"])
      
      puts "Creating OOC chars."
      
      headwiz = Character.create(name: "Headwiz")
      headwiz.change_password("change_me!")
      headwiz.roles.add admin_role
      headwiz.roles.add coder_role
      headwiz.roles.add everyone_role
      headwiz.room = welcome_room
      headwiz.save
  
      builder = Character.create(name: "Builder", is_playerbit: true)
      builder.change_password("change_me!")
      builder.roles.add builder_role
      builder.roles.add everyone_role
      builder.room = welcome_room
      builder.save
  
      systemchar = Character.create(name: "System")
      Login.set_random_password(systemchar)
      systemchar.roles.add admin_role
      systemchar.roles.add everyone_role
      systemchar.room = welcome_room
      systemchar.save

      4.times do |n|
        guest = Character.create(name: "Guest-#{n+1}")
        guest.roles.add guest_role
        guest.roles.add everyone_role
        guest.room = welcome_room
        guest.save
      end

      game.master_admin = headwiz
      game.system_character = systemchar
      game.save
        
      puts "Creating channels and BBS."
  
      board = BbsBoard.create(name: "Announcements", order: 1)
      board.write_roles.add admin_role
      board.save
      
      board = BbsBoard.create(name: "Admin", order: 2)
      board.read_roles.add admin_role
      board.write_roles.add admin_role
      board.save
      
      board = BbsBoard.create(name: "New Arrivals", order: 3)
      board.write_roles.add approved_role
      board.save
      
      board = BbsBoard.create(name: "Trending Scenes", order: 4)
      board.write_roles.add admin_role
      board.save
  
      channel = AresMUSH::Channel.create(name: "Chat", 
          announce: false, 
          description: "Public chit-chat",
          color: "%xy")
      channel.default_alias = [ 'ch', 'cha' ]
      channel.save
      
      channel = AresMUSH::Channel.create(name: "Questions",
         color: "%xg",
         description: "Questions and answers.")
      channel.default_alias = [ 'qu', 'que' ]
      channel.save
      
      channel = AresMUSH::Channel.create(name: "Game",
         color: "%xc",
         description: "System messages.")
      channel.default_alias = [ 'gam' ]
      channel.save
      
      channel = AresMUSH::Channel.create(name: "RP Requests",
         color: "%xB",
         description: "Look for RP. No spam.")
      channel.default_alias = [ 'rp' ]
      channel.save
      
      channel = AresMUSH::Channel.create(name: "FS3 Rolls",
         color: "%xb",
         description: "Roll results.")
      channel.default_alias = [ 'fs3' ]
      channel.save
      
      channel = AresMUSH::Channel.create(name: "Admin",
        description: "Admin business.",
        color: "%xr")
      channel.default_alias = [ 'adm' ]
      channel.join_roles.add admin_role
      channel.talk_roles.add admin_role
      channel.save
  
  
      puts "Creating wiki."
      
      home = WikiPage.create(name: "home")
      WikiPageVersion.create(wiki_page: home, text: "Wiki home page", character: Game.master.system_character)
      
      puts "Creating job categories."
      
      categories = {
        'APP' => "%xm",
        'BUILD' => "%xy",
        'BUG' => "%xr",
        'CODE' => "%xy",
        'ALERT' => "%xr",
        'MISC' => "%xh",
        'PLOT' => "%xc",
        'REQ' => "%xm",
        'RP' => "%xc",
        'SYS' => "%xh"
      }
     
      categories.each do |name, color|
        JobCategory.create(name: name, color: color)
      end
          
      
      puts "Install complete."
    end
  end
end