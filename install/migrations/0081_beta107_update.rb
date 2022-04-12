module AresMUSH  

  module Migrations
    class MigrationBeta107Update
      def require_restart
        false
      end
      
      def migrate

        Global.logger.debug "Default unified play - third time's the charm?"
        Character.all.each { |c| c.update(unified_play_screen: true) }

      end
    end
  end    
end