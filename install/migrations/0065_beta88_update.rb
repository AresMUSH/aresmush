module AresMUSH  

  module Migrations
    class MigrationBeta88Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Migrating plot scenes."
        Plot.all.each do |p|
          Scene.all.select { |s| s.plots.include?(p) }.each do |s|
            if (!p.scenes.include?(s))
              p.scenes.add s
            end
          end
        end

      end
    end    
  end
end