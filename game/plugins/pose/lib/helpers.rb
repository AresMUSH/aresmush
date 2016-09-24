module AresMUSH
  module Pose
    def self.emit_pose(client, pose, is_emit)
      client.room.clients.each do |c|
        nospoof = ""
        if (is_emit && c.char.nospoof)
          nospoof = "%xc%% #{t('pose.emit_nospoof_from', :name => client.name)}%xn%R"
        end
        c.emit "#{Pose::Api.autospace(c.char)}#{nospoof}#{pose}"
        Global.dispatcher.queue_event PoseEvent.new(client, pose, is_emit)
      end
    end
  end
end