module AresMUSH  

  module Migrations
    class MigrationBeta90Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Update engine keys."
        Game.master.update(player_api_keys: {})
      end
    end    
  end
end