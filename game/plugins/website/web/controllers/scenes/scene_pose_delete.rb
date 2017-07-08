module AresMUSH
  class WebApp
        
    get '/scene/pose/:id/delete', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      erb :"scenes/delete_pose"
    end
    
    post '/scene/pose/:id/delete', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      @pose.delete
      
      flash[:info] = "Deleted!"
      redirect "/scene/#{@pose.scene.id}"
    end
    
  end
end
