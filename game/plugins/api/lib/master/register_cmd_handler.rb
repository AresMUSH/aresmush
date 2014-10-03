module AresMUSH
  module Api
    class ApiRegisterCmdHandlerMaster
      def self.handle(cmd)      
        game = Api.get_destination(cmd.game_id)
        
        if (game.nil?)
          key = Api.generate_key
          game_id = ServerInfo.next_id

          Global.logger.info "Creating new game #{cmd.name}."

          game = ServerInfo.create(name: cmd.name, 
            category: cmd.category, 
            description: cmd.desc,
            host: cmd.host,
            port: cmd.port,
            key: key,
            game_id: game_id)
        else
          Global.logger.info "Updating existing game #{game.game_id} #{cmd.name}."

          game.category = cmd.category
          game.name = cmd.name
          game.description = cmd.desc
          game.host = cmd.host
          game.port = cmd.port
          game.save!
        end
        
        "register #{game.game_id}||#{game.key}"
      end
    end
  end
end