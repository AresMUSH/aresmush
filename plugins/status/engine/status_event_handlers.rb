module AresMUSH
  module Status
    class CharDisconnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.update(afk_message: "")
        char.update(is_afk: false)
      end
    end
  end
end
