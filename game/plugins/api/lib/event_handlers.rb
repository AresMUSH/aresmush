module AresMUSH
  module Api
    class ApiEventHandler
      include Plugin
      
      attr_accessor :last_server_info
    
      def on_char_connected_event(event)
        Api.sync_char_with_master(event.client)
      end
      
      # This event disabled for now - doesn't seem necessary to update the game
      # config every time you load a plugin.
      def disabled_config_updated(event)
        server_config = Global.config['server']
        
        if (last_server_info != server_config)
          if (Global.api_router.is_master?)
            ServerInfo.all.each do |s|
              next if (s.game_id == Game.master.api_game_id)
          
              args = ApiRegisterCmdArgs.new(server_config["hostname"], 
              server_config["port"], 
              server_config["name"], 
              server_config["category"], 
              server_config["description"],
              server_config["website"],
              server_config["game_open"])
            
              cmd = ApiCommand.new("register/update", args.to_s)
              Global.api_router.send_command(s.game_id, nil, cmd)
            end
          else
            args = ApiRegisterCmdArgs.new(
            server_config['hostname'], 
            server_config['port'], 
            server_config['name'], 
            server_config['category'],
            server_config['description'],
            server_config["website"],
            server_config["game_open"])

            if (Game.master.api_game_id == ServerInfo.default_game_id)
              cmd = ApiCommand.new("register", args.to_s)
            else
              cmd = ApiCommand.new("register/update", args.to_s)
            end
            Global.api_router.send_command(ServerInfo.arescentral_game_id, nil, cmd)
          end
        end
      end
      
      def on_cron_event(event)
        config = Global.config['api']['cron']
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