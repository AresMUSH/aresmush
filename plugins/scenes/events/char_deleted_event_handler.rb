module AresMUSH
  module Scenes
    class CharDeletedEventHandler
      def on_event(event)
        char_id = event.char_id
        Scene.all.each do |s|
          if s.invited.any? { |c| c.id == char_id }
            s.invited.replace s.invited.select { |c| c.id != char_id }
          end

          if s.watchers.any? { |c| c.id == char_id }
            s.watchers.replace s.watchers.select { |c| c.id != char_id }
          end

          if s.participants.any? { |c| c.id == char_id }
            s.participants.replace s.participant.select { |c| c.id != char_id }
          end

          if s.likers.any? { |c| c.id == char_id }
            s.likers.replace s.likers.select { |c| c.id != char_id }
          end

        end
      end
    end
  end
end