module AresMUSH
  module Pose
    def self.emit_pose(client, pose, is_emit)
      room = client.room
      room.clients.each do |c|
        nospoof = ""
        if (is_emit && c.char.nospoof)
          nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => client.name)}%xn%R"
        end
        c.emit "#{Pose::Api.autospace(c.char)}#{nospoof}#{pose}"
        
        room.poses << pose
        if (room.poses.count > 8)
          room.poses.shift
        end
        room.save!
        
        Global.dispatcher.queue_event PoseEvent.new(client, pose, is_emit)
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