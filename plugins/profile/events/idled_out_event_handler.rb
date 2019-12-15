module AresMUSH
  module Profile
    class CharIdledOutEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.update(profile_tags: char.profile_tags.select { |t| !t.start_with?("player:") })
      end
    end
  end
end