module AresMUSH
  module Api
    class PingCmdHandler
      include ApiCommandHandler
      
      def self.commands
        ["ping"]
      end

      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        false
      end
            
      def handle
        game = ServerInfo.find_by_dest_id(game_id)
        if (game.nil?)
          return cmd.create_error_response t('api.game_not_found')
        end
        
        game.last_ping = Time.now
        game.save!
        
        cmd.create_ok_response
      end
    end
  end
end