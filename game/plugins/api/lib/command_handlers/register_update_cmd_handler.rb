module AresMUSH
  module Api
    class RegisterUpdateCmdHandler
      include ApiCommandHandler
      attr_accessor :args
      
      def self.commands
        ["register/update"]
      end
      
      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        true
      end
      
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
        
        game = ServerInfo.find_by_dest_id(game_id)
        if (game.nil?)
          return cmd.create_error_response(t('api.game_not_found'))
        end
        
        Global.logger.info "Updating existing game #{game.game_id} #{args.name}."

        game.category = args.category
        game.name = args.name
        game.description = args.desc
        game.host = args.host
        game.port = args.port
        game.website = args.website
        game.game_open = args.game_open
        game.last_ping = Time.now
        game.save!
        
        
        cmd.create_ok_response
      end
    end
  end
end