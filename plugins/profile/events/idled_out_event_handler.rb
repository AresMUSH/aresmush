module AresMUSH
  module Profile
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        Global.logger.debug "Clearing alt info for #{event.char_id}"

        char = Character[event.char_id]
        if (char.profile_tags.any? { |t| t.start_with?("player")})
          char.update(profile_tags: char.profile_tags.select { |t| !t.start_with?("player:") })
        end
      end
    end
  end
end