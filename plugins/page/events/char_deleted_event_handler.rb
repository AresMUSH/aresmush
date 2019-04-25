module AresMUSH
  module Page   
    class CharDeleteddEventHandler
      def on_event(event)
        Character.all.select { |c| c.page_ignored.any? { |p| p.id == event.char_id }}.each do |c|
          c.page_ignored.replace c.page_ignored.select { |p| p.id != event.char_id }
        end
      end
    end
  end
end
