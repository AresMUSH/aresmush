module AresMUSH  

  module Migrations
    class Migration2x7x0Update
      def require_restart
        true
      end
      
      def migrate
        # Clear all blank aliases
        Character.all.select { |c| c.alias == "" }.each { |c| c.update(alias: nil) }
      end
    end
  end    
end