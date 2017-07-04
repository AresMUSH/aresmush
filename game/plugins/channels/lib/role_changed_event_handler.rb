module AresMUSH
  module Channels    
    class RoleChangedEventHandler
      def on_event(event)
        char = event.char
        char.channels.each do |channel|
          if (!Channels.can_use_channel(char, channel))        
            Channels.leave_channel(char, channel)
          end
        end
      end
    end
  end
end
