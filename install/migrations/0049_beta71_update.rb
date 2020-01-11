module AresMUSH  

  module Migrations
    class MigrationBeta71Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing scene complete date and last activity on vignettes."
        Scene.all.select { |s| s.completed && !s.date_completed }.each { |s| s.update(date_completed: s.created_at) }
        Scene.all.select { |s| !s.completed && !s.last_activity }.each { |s| s.update(last_activity: Time.now) }
      end 
    end
  end
end