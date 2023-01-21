module AresMUSH
  module Profile
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        Global.logger.debug "Clearing alt info for #{event.char_id}"

        char = Character[event.char_id]
        if (char.content_tags.any? { |t| t.start_with?("player")})
          Website.update_tags(char, char.content_tags.select { |t| !t.start_with?("player:") })
        end
        
        # Bit random for this to be here, but there's no better place to put it.
        char.update(screen_reader: false)
        char.update(color_mode: "FANSI")
        
      end
    end
  end
end