module AresMUSH  

  module Migrations
    class MigrationBeta57Update
      def require_restart
        false
      end
      
      def migrate
        
        Channel.all.each do |c|
          c.roles.each do |r|
            c.join_roles.add r
            c.talk_roles.add r
          end
        end
        
      end 
    end
  end
end