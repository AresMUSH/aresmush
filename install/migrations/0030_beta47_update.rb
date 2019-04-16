module AresMUSH  
  module Migrations
    class MigrationBeta47Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Initiailizing recall text."
        Character.all.each do |c|
          if (!c.utils_saved_text)
            c.update(utils_saved_text: [])
          end
        end
        
      end
    end
  end
end
