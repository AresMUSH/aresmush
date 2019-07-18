module AresMUSH
  module Channels    
    class RoleDeletedEventHandler
      def on_event(event)
        role_id = event.role_id
        Channel.all.each do |channel|
          channel.talk_roles.replace(channel.talk_roles.select { |r| r.id != role_id })
          channel.join_roles.replace(channel.join_roles.select { |r| r.id != role_id })
        end
      end
    end
  end
end
