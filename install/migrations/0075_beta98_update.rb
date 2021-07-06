module AresMUSH  

  module Migrations
    class MigrationBeta98Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Adding plot tags."
        Plot.all.each { |p| p.update(tags: [])}
      end
    end
  end    
end