module AresMUSH
  module Bbs
    class RolesDeletedEventHandler
      def on_event(event)
        BbsBoard.all.each do |board|
          board.read_roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from bbs read role #{board.name}."
              board.read_roles.delete r
            end
          end
          
          board.write_roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from bbs write role #{board.name}."
              board.write_roles.delete r
            end
          end
        end
      end
    end
  end
end