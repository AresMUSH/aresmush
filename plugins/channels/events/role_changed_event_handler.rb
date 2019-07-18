module AresMUSH
  module Channels    
    class RoleChangedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.channels.each do |channel|
          if (!Channels.can_join_channel?(char, channel))        
            Channels.leave_channel(char, channel)
          end
        end
      end
    end
  end
end
