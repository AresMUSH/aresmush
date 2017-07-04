module AresMUSH
  module Channels    
    class RoleDeletedEventHandler
      def on_event(event)
        Channel.all.each do |channel|
          channel.roles.each do |r|
            if (r.id == event.role_id)
              Global.logger.debug "Deleting role from channel #{channel.name}."
              channel.roles.delete r
            end
          end
        end
      end
    end
  end
end
