module AresMUSH
  module Api
    class SlaveRegisterResponseHandler
      attr_accessor :game_id, :api_key, :client
      
      def initialize(client, response)
        @client = client
        
        args = response.args.split("||")
        raise "Registration error: #{response.args}" if args.count != 2
        @game_id = Integer(args[0])
        @api_key = args[1]
      end
      
      def handle
        game = Game.master
        game.api_game_id = @game_id
        game.save

        central = Api.get_destination(ServerInfo.arescentral_game_id)
        if (central.nil?)
          raise "Can't find AresCentral server info."
        end
        central.key = @api_key
        central.save
        
        Global.logger.info "API info updated."
      end
    end
  end
end