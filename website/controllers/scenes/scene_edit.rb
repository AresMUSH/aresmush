module AresMUSH
  class WebApp
    
    get '/scene/:id/edit/?', :auth => :approved do |id|
      @scene = Scene[id]
      @log = @scene.scene_log
      
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
      
      @scene.scene_log.update(log: params[:log])
      @scene.update(location: params[:location])
      @scene.update(summary: params[:summary])
      @scene.update(scene_type: params[:scene_type])
      @scene.update(title: params[:title])
      @scene.update(icdate: params[:icdate])
      
      tags = params[:tags] || ""
      @scene.update(tags: tags.split(" ").map { |t| t.downcase })
      
      flash[:info] = "Scene updated!"
      redirect "/scene/#{id}"
    end
    
    get '/scene/:id/delete', :auth => :admin do |id|
      @scene = Scene[id]
      if (!@scene)
        flash[:error] = "That scene does not exist!"
        redirect "/scenes"
      end

      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"/scenes/delete_scene"
    end
    
    get '/scene/:id/delete/confirm', :auth => :admin do |id|
      @scene = Scene[id]
      if (!@scene)
        flash[:error] = "That scene does not exist!"
        redirect "/scenes"
      end
      @scene.delete
      flash[:info] = "Scene deleted!"
      redirect "/scenes"
    end
    
    
  end
end
