module AresMUSH
  module Api
    class ApiRegisterCmdHandlerSlave
      def self.handle(cmd)      
        game = Api.get_destination(cmd.game_id)
        
        if (game.nil?)
          "register Cannot find game information."
        else
          Global.logger.info "Updating existing game #{game.game_id} #{cmd.name}."

          game.category = cmd.category
          game.name = cmd.name
          game.description = cmd.desc
          game.host = cmd.host
          game.port = cmd.port
          game.save!
                    
          "register OK"
        end
      end
    end
  end
end