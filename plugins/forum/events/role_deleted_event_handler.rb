module AresMUSH
  module Forum
    class RoleDeletedEventHandler
      def on_event(event)
        BbsBoard.all.each do |category|
          category.read_roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from forum (read) #{category.name}."
              category.read_roles.delete r
            end
          end
          
          category.write_roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from forum (write) #{category.name}."
              category.write_roles.delete r
            end
          end
        end
      end
    end
  end
end