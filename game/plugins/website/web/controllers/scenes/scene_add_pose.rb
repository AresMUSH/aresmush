module AresMUSH
  class WebApp
    
    get '/scene/:id/pose/add' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/add_pose"
    end
    
    post '/scene/:id/pose/add', :auth => :approved do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}"
      end
      
      pose = params[:pose]
      if (pose.blank?)
        flash[:error] = "Pose is required!"
        redirect "/scene/#{@scene.id}/pose/add"
      end
      
      Scenes.add_pose(@scene, pose, @user)
      
      flash[:info] = "Pose added!  You can use the arrows to move it around if necessary."
      redirect "/scene/#{@scene.id}"
    end
    
  end
end
