module AresMUSH
  module Api
    class SlaveRegisterResponseHandler
      include ApiResponseHandler

      attr_accessor :args

      def self.commands
        ["register"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
    
      def crack!
        self.args = ApiRegisterResponseArgs.create_from(response.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        game = Game.master
        game.api_game_id = args.game_id
        game.save

        central = Api.get_destination(ServerInfo.arescentral_game_id)
        if (central.nil?)
          raise "Can't find AresCentral server info."
        end
        central.key = args.api_key
        central.save
        
        Global.logger.info "Game registered with AresCentral."
      end
    end
  end
end