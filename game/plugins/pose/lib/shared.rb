module AresMUSH
  module Pose
    def self.emit_pose(room, pose)
      room.clients.each do |c|
        c.emit "#{c.char.autospace}#{pose}"
      end
    end
  end
end