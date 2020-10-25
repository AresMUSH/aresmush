module AresMUSH  

  module Migrations
    class MigrationBeta87Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding profile order."
        Character.all.each { |c| c.update(profile_order: [])}
        
      end
    end    
  end
end