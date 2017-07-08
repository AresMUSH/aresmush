module AresMUSH
  class WebApp
    
    get '/scene/pose/:id/moveup', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      scene = @pose.scene
      
      poses = {}
      found_index = nil
      scene.poses_in_order.each_with_index do |p, i|
        poses[i] = p
        if (p == @pose)
          found_index = i
        end
      end
      
      if (found_index == 0)
        redirect "/scene/#{@pose.scene.id}"
      end

      temp = poses[found_index - 1]
      poses[found_index - 1] = @pose
      poses[found_index] = temp

      poses.each do |order, pose|
        pose.update(order: order)
      end

      redirect "/scene/#{@pose.scene.id}"
    end
    
    
    get '/scene/pose/:id/movedown', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      scene = @pose.scene
      
      poses = {}
      found_index = nil
      scene.poses_in_order.each_with_index do |p, i|
        poses[i] = p
        if (p == @pose)
          found_index = i
        end
      end
      
      if (found_index == poses.count - 1)
        redirect "/scene/#{@pose.scene.id}"
      end

      temp = poses[found_index + 1]
      poses[found_index + 1] = @pose
      poses[found_index] = temp

      poses.each do |order, pose|
        pose.update(order: order)
      end

      redirect "/scene/#{@pose.scene.id}"
    end

  end
end
