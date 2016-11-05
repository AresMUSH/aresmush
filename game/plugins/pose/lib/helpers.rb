module AresMUSH
  module Pose
    def self.emit_pose(enactor, pose, is_emit, is_ooc)
      room = enactor.room
      Global.client_monitor.logged_in.each do |client, char|
        next if char.room != enactor.room
        client.emit Pose.custom_format(pose, char, is_emit, is_ooc)
      end
      
      if (!is_ooc)
        Pose.add_repose(room, enactor, pose)
        Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit)
      end
    end

    def self.add_repose(room, enactor, pose)
      repose = room.repose_info
      return if !repose
      
      order = repose.pose_orders 
      enactor_order = order.find(character_id: enactor.id).first
      if (enactor_order)
        enactor_order.update(time: Time.now)
      else
        PoseOrder.create(repose_info: repose, character: enactor, time: Time.now)
      end

      poses = repose.poses
      poses << pose
      if (poses.count > 8)
        poses.shift
      end
      repose.update(poses: poses)
    end
    
    def self.repose_enabled
      Global.read_config("pose", "repose_enabled")
    end
    
    def self.reset_reposes
      # Don't clear poses in rooms with active people.
      active_rooms = Global.client_monitor.logged_in.map { |client, char| char.room }


      rooms = Room.all.group_by { |r| !!r.repose_info }
      enabled_rooms = rooms[true] || []
      disabled_rooms = rooms[false] || []

      enabled_rooms.each do |r|
        next if active_rooms.include?(r)
        
        Global.logger.debug "Clearing poses from #{r.name}."
        r.repose_info.delete
        r.update(repose_info_id: nil)
        disabled_rooms << r
      end
    
      
      disabled_rooms.each do |r|
        next if active_rooms.include?(r)
        Pose.reset_repose(r)
      end
    end
    
    def self.reset_repose(room)
      repose = room.repose_info
      
      if ((room.room_type == "IC" || room.room_type == "RPR") && !repose)
        Global.logger.debug "Enabling repose in #{room.name}."
        repose = ReposeInfo.create(room: room)
        room.update(repose_info: repose)
      elsif repose
        repose.delete
      end
    end
    
    def self.custom_format(pose, char, enactor, is_emit = false, is_ooc = false)
      nospoof = ""
      if (is_emit && char.pose_nospoof)
        nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => enactor.name)}%xn%R"
      end
      
      quote_color = char.pose_quote_color
      if (is_ooc || quote_color.blank?)
        colored_pose = pose
      else
        matches = pose.scan(/([^"]+)?("[^"]+")?/)
        colored_pose = ""
        matches.each do |m| 
          if (m[0])
            colored_pose << "#{m[0]}"
          end
          if (m[1])
            colored_pose << "#{quote_color}#{m[1]}%xn"
          end
        end
      end
      
      "#{char.pose_autospace}#{nospoof}#{colored_pose}"
    end
    
  end
end