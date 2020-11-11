module AresMUSH  

  module Migrations
    class MigrationBeta89Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Mark coder role restricted."
        role = Role.find_one_by_name("coder")
        if (role)
          role.update(is_restricted: true)
        end
      end
    end    
  end
end