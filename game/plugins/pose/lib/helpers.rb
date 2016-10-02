module AresMUSH
  module Pose
    def self.emit_pose(enactor, pose, is_emit, is_ooc)
      room = enactor.room
      Global.client_monitor.logged_in.each do |client, char|
        next if char.room != enactor.room
        nospoof = ""
        if (is_emit && char.nospoof)
          nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => enactor.name)}%xn%R"
        end
        client.emit "#{Pose::Api.autospace(char)}#{nospoof}#{pose}"
      end
      
      if (!is_ooc)
        room.pose_order[enactor.name] = Time.now
        room.poses << pose
        if (room.poses.count > 8)
          room.poses.shift
        end
        room.save
        Global.dispatcher.queue_event PoseEvent.new(enactor, pose, is_emit)
      end
    end
    
    def self.repose_enabled
      Global.read_config("pose", "repose_enabled")
    end
    
    def self.repose_on(room)
      repose_enabled && room.repose_on
    end
  end
end