module AresMUSH  

  class Character
    reference :place, "AresMUSH::Place"
  end
  
  module Migrations
    class MigrationBeta58Update
      def require_restart
        true
      end
      
      def migrate
        Character.all.each { |c| c.update(place: nil) }
      end 
    end
  end
end
