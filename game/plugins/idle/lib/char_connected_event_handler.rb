module AresMUSH
  module Idle
    class CharConnectedEventHandler
      def on_event(event)
        char = event.char
        if (char.idle_warned)
          char.update(idle_warned: false)
        end
      end
    end
  end
end