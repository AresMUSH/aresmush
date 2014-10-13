module AresMUSH
  module Api
    class ApiCommandHandler
      include Plugin
           
      attr_accessor :game_id, :cipher_iv, :encrypted_data
      
      def initialize
        Api.create_router
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("api>")
      end
      
      def crack!
        cmd.crack_args!(/(?<game_id>[\S]+) (?<cipher_iv>[\S]+) (?<data>.+)/)
        
        self.game_id = cmd.args.game_id
        self.cipher_iv = cmd.args.cipher_iv
        self.encrypted_data = cmd.args.data
      end
      
      def handle
        AresMUSH.with_error_handling(client, "API handling command from #{self.game_id}: #{command_str}") do
          if (self.game_id == ServerInfo.default_game_id.to_s)
            key = ServerInfo.default_key
          else              
            game = Api.get_destination(self.game_id)
            if (game.nil?)
              raise "Cannot accept commands from #{self.game_id}."
            end
            key = game.key
          end
          command_str = ApiCrypt.decrypt(key, self.cipher_iv, self.encrypted_data)
          response = Api.router.route_command(self.game_id, command_str)
          Api.send_response client, key, "api< #{response}"
        end
      end
    end
  end
end