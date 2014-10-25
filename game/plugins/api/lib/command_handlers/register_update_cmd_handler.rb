module AresMUSH
  module Api
    class RegisterUpdateCmdHandler
      include ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiRegisterCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end

      def handle
        if (game_id == ServerInfo.default_game_id)
          return cmd.create_error_response(t('api.game_not_registered'))
        end
        
        game = Api.get_destination(game_id)
        if (game.nil?)
          return cmd.create_error_response(t('api.game_not_found'))
        end
        
        Global.logger.info "Updating existing game #{game.game_id} #{args.name}."

        game.category = args.category
        game.name = args.name
        game.description = args.desc
        game.host = args.host
        game.port = args.port
        game.save!
        
        cmd.create_ok_response
      end
    end
  end
end