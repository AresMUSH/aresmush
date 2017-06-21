module AresMUSH
  class WebApp
   
    get '/scenes' do
      @scenes = Scene.all.select { |s| !s.private_scene }
      erb :"scenes/index"
    end
    
    get '/scene/:id' do |id|
      @scene = Scene[id]
      
      erb :"scenes/log"
    end
    
    get '/scene/:id/wiki' do |id|
      @scene = Scene[id]
      
      erb :"scenes/wiki"
    end
    
    get '/scene/pose/:id/delete' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      erb :"scenes/delete_pose"
    end
    
    post '/scene/pose/:id/delete' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      @pose.delete
      
      flash[:info] = "Deleted!"
      redirect "/scene/#{@pose.scene.id}"
    end
    
    get '/scene/pose/:id/edit' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      erb :"/scenes/edit_pose"
    end
    
    post '/scene/pose/:id/edit' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      text = format_input_for_mush @params[:pose]
      @pose.update(pose: text)
      
      flash[:info] = "Updated!"
      redirect "/scene/#{@pose.scene.id}"
    end
    
  end
end
