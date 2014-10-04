module AresMUSH
  module Api
    class ApiEventHandler
      include Plugin
      
      attr_accessor :last_server_info
    
      def on_config_updated_event(event)
        
        server = Global.config['server']
        
        
        # TODO - uncomment so this doesn't happen every time.
        #if (last_server_info != server_info)

        Api.router.send_game_update
       # end
      end
    end
  end
end