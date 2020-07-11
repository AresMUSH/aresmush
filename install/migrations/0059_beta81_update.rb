module AresMUSH  

  module Migrations
    class MigrationBeta81Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Removing orphanned handles."
        Handle.all.select { |h| !h.character }.each { |h| h.delete }
      end
    end    
  end
end