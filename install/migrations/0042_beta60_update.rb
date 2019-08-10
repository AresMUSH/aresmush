module AresMUSH  

  module Migrations
    class MigrationBeta60Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Setting default forum/scan connect."
        Character.all.each do |char|
          if (!char.onconnect_commands)
            char.update(onconnect_commands: [])
          elsif (!char.onconnect_commands.include?('forum/scan') && !char.onconnect_commands.include?('bbscan'))
            cmds = char.onconnect_commands
            cmds << 'forum/scan'
            char.update(onconnect_commands: cmds)
          end
        end
      end 
    end
  end
end