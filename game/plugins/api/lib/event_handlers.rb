module AresMUSH
  module Api
    class ApiEventHandler
      include Plugin
      
      attr_accessor :last_server_info
    
      def on_config_updated_event(event)
        server_config = Global.config['server']
        
        if (last_server_info != server_config)
          if (Api.is_master?)
            ServerInfo.all.each do |s|
              next if (s.game_id == Game.master.api_game_id)
          
              args = ApiRegisterCmdArgs.new(server_config["hostname"], 
              server_config["port"], 
              server_config["name"], 
              server_config["category"], 
              server_config["description"])
            
              cmd = ApiCommand.new("register/update", args.to_s)
              Api.send_command(s.game_id, nil, cmd)
            end
          else
            args = ApiRegisterCmdArgs.new(
            server_config['hostname'], 
            server_config['port'], 
            server_config['name'], 
            server_config['category'],
            server_config['description'])

            if (Game.master.api_game_id == ServerInfo.default_game_id)
              cmd = ApiCommand.new("register", args.to_s)
            else
              cmd = ApiCommand.new("register/update", args.to_s)
            end
            Api.send_command(ServerInfo.arescentral_game_id, nil, cmd)
          end
        end
      end
      
      def on_cron_event(event)
        config = Global.config['api']['cron']
        return if !Cron.is_cron_match?(config, event.time)
        return if Api.is_master?
        
        chars = []
        Global.client_monitor.logged_in_clients.each do |c|
          chars << "#{c.name}:#{c.char.handle}"
        end
        args = ApiPingCmdArgs.new(chars)
        cmd = ApiCommand.new("ping", args.to_s)
        Api.send_command ServerInfo.arescentral_game_id, nil, cmd
      end
    end
  end
end