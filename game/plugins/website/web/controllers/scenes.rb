module AresMUSH
  class WebApp
    def can_access_scene?(scene)
      Scenes.can_access_scene?(@user, scene)
    end
    
    get '/scenes' do
      @scenes = Scene.all.select { |s| s.shared }.sort_by { |s| s.created_at }.reverse
      erb :"scenes/index"
    end
    
    get '/scene/:id' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/log"
    end
    
    get '/scene/:id/edit' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/edit_scene"
    end
    
    get '/scene/:id/pose/add' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/add_pose"
    end
    
    get '/scene/pose/:id/delete' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      erb :"scenes/delete_pose"
    end
    
    get '/scenes/create', :auth => :approved do 
      erb :"scenes/create_scene"
    end
    
    get '/scene/pose/:id/moveup' do |id|
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
    
    
    get '/scene/pose/:id/movedown' do |id|
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
        
    get '/scene/pose/:id/edit' do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      erb :"/scenes/edit_pose"
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
    
    post '/scene/pose/:id/edit', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      text = format_input_for_mush params[:pose]
      @pose.update(pose: text)
      @pose.update(is_setpose: params[:is_setpose])
      
      char_id = params[:character]
      if (char_id != @pose.character.id)
        @pose.update(character: Character[char_id])
      end
      
      flash[:info] = "Updated!"
      redirect "/scene/#{@pose.scene.id}"
    end
    
    post '/scene/:id/edit', :auth => :approved do |id|
      @scene = Scene[id]
      
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{id}"
      end
      
      
      @scene.update(location: params[:location])
      @scene.update(summary: params[:summary])
      @scene.update(scene_type: params[:scene_type])
      @scene.update(title: params[:title])
      @scene.update(icdate: params[:icdate])
      
      flash[:info] = "Scene updated!"
      redirect "/scene/#{id}"
    end
    
    post '/scenes/create', :auth => :approved do
      
      @scene = Scene.create(
      location: params[:location],
      summary: params[:summary],
      scene_type: params[:scene_type],
      title: params[:title],
      icdate: params[:icdate],
      shared: true,
      completed: true
      )
      
      Scenes.add_pose(@scene, params[:log], @user)
      
      flash[:info] = "Scene created!"
      redirect "/scene/#{@scene.id}"
    end
    
  end
end
