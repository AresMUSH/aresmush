module AresMUSH
  module Pose
    def self.emit_pose(enactor, pose, is_emit, is_ooc, place_name = nil)
      room = enactor.room
      
      if (is_ooc)
        color = Global.read_config("pose", "ooc_color")
        pose = "#{color}<OOC>%xn #{pose}"
      end
      
      Global.client_monitor.logged_in.each do |client, char|
        next if char.room != enactor.room
        client.emit Pose.custom_format(pose, char, enactor, is_emit, is_ooc, place_name)
      end
      
      if (!is_ooc)
        Pose.add_repose(room, enactor, pose)
        Pose.notify_next_person(room)
        Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit)
      end
    end
    
    def self.add_repose(room, enactor, pose)
      return if !room.repose_on?
      
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
    
    def self.notify_next_person(room)
      return if !room.repose_on?
      
      repose = room.repose_info
      return if repose.first_turn
      return if repose.sorted_orders.count < 3
        
      next_up_order = repose.sorted_orders.first
      next_up_char = next_up_order.character

      if ((next_up_char.room != room) || !next_up_char.client)
        next_up_order.delete
        Pose.notify_next_person(room)
      elsif (next_up_char.repose_nudge && !next_up_char.repose_nudge_muted)
        next_up_char.client.emit_ooc t('pose.repose_your_turn')
      else
        
      end
    end
    
    def self.repose_enabled
      Global.read_config("pose", "repose_enabled")
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
    
    def self.custom_format(pose, char, enactor, is_emit = false, is_ooc = false, place_name = nil)
      nospoof = ""
      if (is_emit && char.pose_nospoof)
        nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => enactor.name)}%xn%R"
      end
      
      if (place_name)
        same_place = (char.place ? char.place.name : nil) == place_name
        place_title = Places::Api.place_title(place_name, same_place)
      else
        place_title = is_ooc ? "" : enactor.place_title(char)
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
      
      "#{char.pose_autospace}#{nospoof}#{place_title}#{colored_pose}"
    end
    
  end
end