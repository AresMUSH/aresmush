module AresMUSH
  module Api
    class MasterRegisterCmdHandler
      def self.handle(cmd)              
        if (cmd.game_id != ServerInfo.default_game_id)
          return ApiResponse.create_error_response(cmd, "Game has already been registered.")
        end
       
        key = ApiCrypt.generate_key
        game_id = ServerInfo.next_id

        Global.logger.info "Creating new game #{cmd.name}."

        game = ServerInfo.create(name: cmd.name, 
          category: cmd.category, 
          description: cmd.desc,
          host: cmd.host,
          port: cmd.port,
          key: key,
          game_id: game_id)
        
        cmd.build_response(game_id, key)
      end
    end
  end
end