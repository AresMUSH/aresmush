module AresMUSH
  module Api
    class ApiEventHandler
      include Plugin
      
      attr_accessor :last_server_info
    
      def on_config_updated_event(event)
        server = Global.config['server']
        
        # TODO - if master, send update to all games
        
        # TODO - uncomment so this doesn't happen every time.
        #if (last_server_info != server_info)
          cmd = ApiRegisterCmd.new(
            Game.master.api_game_id,
            server['hostname'], 
            server['port'], 
            server['name'], 
            server['category'],
            server['description'])
          Api.send_command(ServerInfo.arescentral_game_id, nil, cmd.build_command_str)
       # end
      end
    end
  end
end