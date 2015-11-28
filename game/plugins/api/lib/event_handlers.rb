module AresMUSH
  module Api
    class ApiEventHandler
      include CommandHandler
      
      attr_accessor :last_server_info
    
      def on_char_connected_event(event)
        Api.sync_char_with_master(event.client)
      end
      
      def on_game_started_event(event)
        server_config = Global.read_config("server")
        game_config = Global.read_config("game")
        
        if (Global.api_router.is_master?)
          ServerInfo.all.each do |s|
            next if (s.game_id == Game.master.api_game_id)
          
            args = ApiRegisterCmdArgs.new(server_config["hostname"], 
            server_config["port"], 
            game_config["name"], 
            game_config["category"], 
            game_config["description"],
            game_config["website"],
            game_config["game_open"])
            
            cmd = ApiCommand.new("register/update", args.to_s)
            Global.api_router.send_command(s.game_id, nil, cmd)
          end
        else
          args = ApiRegisterCmdArgs.new(
             server_config['hostname'], 
             server_config['port'], 
             game_config['name'], 
             game_config['category'],
             game_config['description'],
             game_config["website"],
             game_config["game_open"])
         
          if (Game.master.api_game_id == ServerInfo.default_game_id)
            cmd = ApiCommand.new("register", args.to_s)
          else
            cmd = ApiCommand.new("register/update", args.to_s)
          end
          Global.api_router.send_command(ServerInfo.arescentral_game_id, nil, cmd)
        end
      end
      
      def on_cron_event(event)
        config = Global.read_config("api", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        return if Global.api_router.is_master?
        
        chars = []
        Global.client_monitor.logged_in_clients.each do |c|
          chars << "#{c.name}:#{c.char.handle}"
        end
        args = ApiPingCmdArgs.new(chars)
        cmd = ApiCommand.new("ping", args.to_s)
        Global.api_router.send_command ServerInfo.arescentral_game_id, nil, cmd
      end
    end
  end
end