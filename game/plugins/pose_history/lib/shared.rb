module AresMUSH
  module Pose_History
    
    # Begin a new Pose History. This should only be done if one doesn't exist at all
    def self.initiate_history(room, name, time, pose)
      @pose_history = Hash.new
      @pose_history[room] = {}
      @pose_history[room][time] = { :pose => pose, :name => name}
      
    end
    
    def self.add_pose(room, name, time, pose)
      # Add a new room to the existing hash.
      @pose_history[room] = {} if @pose_history[room].nil?
      @pose_history[room][time] = { :pose => pose, :name => name}
    end
    
    
  end
end