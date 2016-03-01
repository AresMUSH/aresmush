module AresMUSH
  module Pose_Order
  
  mattr_accessor :po
    
    # Begin a new Pose History. This should only be done if one doesn't exist at all
    def self.initiate_order(room, name, time)
      Pose_Order.po = Hash.new {}
      add_to_order(room, name, time)
    end
    
    def self.add_to_order(room, name, time)
      # Add a new room to the existing hash.
      Pose_Order.po[room] = {} if Pose_Order.po[room].nil?
      # If the character is in the hash already, update their time.
      Pose_Order.po[room][name] = { :time => time}
    end
    
    
  end
end
