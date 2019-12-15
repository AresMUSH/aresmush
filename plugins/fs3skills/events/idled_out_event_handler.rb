module AresMUSH
  module FS3Skills
    class CharIdledOutEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.reset_xp
      end
    end
  end
end