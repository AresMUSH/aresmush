module AresMUSH  

  module Migrations
    class MigrationBeta106Update
      def require_restart
        false
      end
      
      def migrate

        Global.logger.debug "Default unified play - again."
        Character.all.each { |c| c.update(unified_play: true) }

      end
    end
  end    
end