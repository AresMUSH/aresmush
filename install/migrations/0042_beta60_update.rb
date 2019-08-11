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
        
        Global.logger.debug "Adding reference id to notifications"
        LoginNotice.all.each do |n|
          case n.type
          when "event", "mail", "job" 
            if (n.data.blank?)
              n.delete
            else
              n.update(reference_id: n.data)
            end
          when "forum"
            post = n.data ? n.data.after('|') : ""
            if (post.blank?)
              n.delete
            else
              n.update(reference_id: post)
            end
          end
        end
      end 
    end
  end
end