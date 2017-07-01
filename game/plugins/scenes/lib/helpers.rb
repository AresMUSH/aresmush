module AresMUSH
  module Scenes
    def self.can_manage_scene(actor, scene)
      return false if !actor
      (scene.owner == actor) || 
      actor.has_permission?("manage_scenes")
    end
    
    def self.is_valid_privacy(privacy)
      ["Public", "Private"].include?(privacy)
    end
    
    def self.can_access_scene?(actor, scene)
      return true if Scenes.can_manage_scene(actor, scene)
      return true if !scene.is_private?
      return scene.participants.include?(actor)
    end
    
    
    def self.stop_scene(scene)
      return if scene.completed
      
      scene.room.characters.each do |c|
        connected_client = c.client
        if (connected_client)
          connected_client.emit t('scenes.scene_ending')
        end
        Rooms::Api.send_to_ooc_room(connected_client, c)
      end
      
      scene.room.delete
      
      if (scene.private_scene)
        scene.delete
      else
        scene.update(completed: true)
      end
    end
    
    def self.add_pose(scene_id, pose, character = Game.master.system_character)
      scene = Scene[scene_id]
      scene_pose = ScenePose.create(pose: pose, character: character, scene: scene)
    end
    
    
    def self.add_repose(room, enactor, pose)
      return if !room.repose_on?

      if (room.scene)
      end
      
      repose = room.repose_info
      
      order = repose.pose_orders 
      enactor_order = order.find(character_id: enactor.id).first
      if (enactor_order)
        enactor_order.update(time: Time.now)
        
        # Soeone has acted twice, so we'll assume this is the pose order.
        repose.update(first_turn: false)
      else
        PoseOrder.create(repose_info: repose, character: enactor, time: Time.now)
      end

      poses = repose.poses || []
      poses << pose
      repose.update(poses: poses)
    end    
        
    def self.reset_reposes
      # Don't clear poses in rooms with active people.
      active_rooms = Global.client_monitor.logged_in.map { |client, char| char.room }


      rooms = Room.find(room_type: "IC").union(room_type: "RPR").group_by { |r| r.repose_on? }
      enabled_rooms = rooms[true] || []
      disabled_rooms = rooms[false] || []

      enabled_rooms.each do |r|
        next if active_rooms.include?(r)
        next if r.scene
        
        r.repose_info.reset
      end
    
      
      disabled_rooms.each do |r|
        next if active_rooms.include?(r)
        Pose.reset_repose(r)
      end
    end
    
    def self.reset_repose(room)
      repose = room.repose_info
      
      if (room.room_type == "IC" || room.room_type == "RPR")
        if (repose)
          repose.update(enabled: true)
        else
          repose = ReposeInfo.create(room: room, enabled: true)
          room.update(repose_info: repose)
        end
      elsif (repose)
        repose.delete
      end
    end
    
    def self.enable_repose(room)
      return if (room.repose_on?)
      repose = room.repose_info
      if (!repose)
        repose = ReposeInfo.create(room: room, poses: [])
        room.update(repose_info: repose)
      end
      repose.update(enabled: true)
    end
    
    
    
    def self.reset_poses(scene_id)
      scene = Scene[scene_id]
      scene.scene_poses.each { |p| p.delete }
    end
    
    def self.get_log(scene_id, actor)
      scene = Scene[scene_id]
      if (!scene)
        return { log: nil, error: t('scenes.scene_not_found') }
      end
      
      if (!Scenes.can_access_scene?(actor, scene))
        return { log: nil, error: t('scenes.access_not_allowed') }
      end
      
      log = SceneLog.new
      log.ictime = scene.ictime
      log.title = scene.title
      log.location = scene.location
      log.summary = scene.summary
      log.participants = scene.participants
      log.poses = []
      
      scene.scene_poses.each do |p|
        log.poses << SceneLogPose.new(p)
      end
      return { log: log, error: nil }
    end
  end
end
