module AresMUSH
  module Pose_Order
    
    # When a pose is sent through, it triggers this method. 
    # update_history takes the following:
    # room -> Key value for hash
    # name -> Key value for nested hash
    # time -> Nested hash value
    # pose -> Nested hash value
    def self.update_order(room, name, time)
      if (Pose_Order.po.nil?)
        Pose_Order.initiate_order(room, name, time)
        
      else
        Pose_Order.add_to_order(room, name, time)
        
      end
    end
  end
end



