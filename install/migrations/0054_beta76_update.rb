module AresMUSH  

  module Migrations
    class MigrationBeta76Update
      def require_restart
        true
      end
      
      def migrate
        Global.logger.debug "Add emoji config option."
        Character.all.each { |c| c.update(emoji_enabled: true)}
      end 
    end
  end
end