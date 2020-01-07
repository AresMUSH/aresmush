module AresMUSH  

  module Migrations
    class MigrationBeta71Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing scene complete date on vignettes."
        Scene.all.select { |s| s.completed && !s.date_completed }.each { |s| s.update(date_completed: s.created_at) }
      end 
    end
  end
end