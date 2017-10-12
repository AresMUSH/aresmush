module AresMUSH
  module Idle
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        if (char.idle_warned)
          char.update(idle_warned: false)
        end
      end
    end
  end
end