module AresMUSH
  module Scenes
    def self.can_manage_scene(actor, scene)
      (scene.owner == actor) || 
      actor.has_permission?("manage_scenes")
    end
    
    def self.is_valid_privacy(privacy)
      ["Public", "Private"].include?(privacy)
    end
    
    def self.stop_scene(scene)
      scene.room.characters.each do |c|
        connected_client = c.client
        if (connected_client)
          connected_client.emit t('scenes.scene_ending')
        end
        Rooms::Api.send_to_ooc_room(connected_client, c)
      end
      
      scene.room.delete
      scene.delete
    end
  end
end
