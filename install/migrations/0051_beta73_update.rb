module AresMUSH  

  module Migrations
    class MigrationBeta73Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Storyteller migration."
        Plot.all.each do |p|
          if (p.storyteller)
            p.storytellers.add p.storyteller
          end
        end
      end 
    end
  end
end