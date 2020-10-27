module AresMUSH  

  module Migrations
    class MigrationBeta88Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Migrating plot scenes."
        Scene.all.each do |s|
          s.plots.each do |p|
            if (!PlotLink.find_link(p, s))
              PlotLink.create(plot: p, scene: s)
            end
          end
        end

      end
    end    
  end
end