module AresMUSH
  module Scenes
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("scenes", "cron")
        return if !Cron.is_cron_match?(config, event.time)
                
        rooms = Room.all.select { |r| !!r.scene_set || !!r.scene || !r.scene_nag}
        rooms.each do |r|
          if (r.clients.empty?)
            if (r.scene_set)
              r.update(scene_set: nil)
            end
            
            if (!r.scene_nag)
              r.update(scene_nag: true)
            end
            
            if (stop_empty_scene(r))
              Global.logger.debug("Stopping scene in #{r.name}")
              Scenes.stop_scene(r.scene)
            end
          end
        end
        
        # Completed scenes that haven't been shared are deleted after a few days.
        Scene.all.select { |s| s.completed && !s.shared }.each do |scene|
          if (DateTime.now.to_date - scene.date_completed > 3)
            Global.logger.warn "Delete Scene - #{scene.id} #{scene.date_completed}"
          end
        end
      end
      
      def stop_empty_scene(room)
        return false if !room.scene
        return true if room.characters.empty?
        return room.scene.temp_room
      end
    end
  end
end