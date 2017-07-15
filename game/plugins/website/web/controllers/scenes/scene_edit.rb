module AresMUSH
  class WebApp
    
    get '/scene/:id/edit', :auth => :approved do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/edit_scene"
    end
    
    post '/scene/:id/edit', :auth => :approved do |id|
      @scene = Scene[id]
      
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{id}"
      end
      
      @scene.update(log: params[:log])
      @scene.update(location: params[:location])
      @scene.update(summary: params[:summary])
      @scene.update(scene_type: params[:scene_type])
      @scene.update(title: params[:title])
      @scene.update(icdate: params[:icdate])
      
      flash[:info] = "Scene updated!"
      redirect "/scene/#{id}"
    end
    
  end
end
