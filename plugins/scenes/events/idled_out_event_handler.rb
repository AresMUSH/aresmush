module AresMUSH
  module Scenes
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to do anything if they're getting destroyed.
        return if event.is_destroyed?
        return if !Global.read_config("scenes", "delete_scenes_on_idle_out")

        Global.logger.debug "Recycling unshared scenes for #{event.char_id}"
        char = Character[event.char_id]
        char.unshared_scenes.each do |scene|
          Scenes.move_to_trash(scene, Game.master.system_character)
        end
      end
    end
  end
end