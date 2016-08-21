module AresMUSH
  module Handles
    class HandlesEventHandler
      include CommandHandler
      
      attr_accessor :last_server_info
    
      def on_char_connected_event(event)
        Handles.sync_char_with_master(event.client)
      end
      
      def on_game_started_event(event)
        # TODO!!
        return
        server_config = Global.read_config("server")
        game_config = Global.read_config("game")
      
        args = ApiRegisterCmdArgs.new(
           server_config['hostname'], 
           server_config['port'], 
           game_config['name'], 
           game_config['category'],
           game_config['description'],
           game_config["website"],
           game_config["game_open"])
       
        cmd = ApiCommand.new("register/update", args.to_s)
        Global.api_router.send_command(ServerInfo.arescentral_game_id, nil, cmd)
      end
      
      def on_cron_event(event)
        # TODO!!
        return
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