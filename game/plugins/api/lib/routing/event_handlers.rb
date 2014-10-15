module AresMUSH
  module Api
    class ApiEventHandler
      include Plugin
      
      attr_accessor :last_server_info
    
      def on_config_updated_event(event)
        server_config = Global.config['server']
        
        if (last_server_info != server_info)
          Api.router.send_game_update(server_config)
        end
      end
      
      def on_cron_event(event)
        config = Global.config['api']['cron']
        #return if !Cron.is_cron_match?(config, event.time)
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