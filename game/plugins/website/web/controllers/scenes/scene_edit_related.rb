module AresMUSH
  class WebApp
        
    get '/scene/:id/related', :auth => :approved do |id|
      @scene = Scene[id]
      @available_scenes = Scene.all.to_a.select { |s| s.shared && s.id != id }.sort_by { |s| s.icdate }.reverse
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/edit_related"
    end
    
    
    get '/scene/:scene_id/related/delete/:related_id', :auth => :approved do |scene_id, related_id|
      @scene = Scene[scene_id]
      @related = Scene[related_id]
      
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}"
      end
      
      @scene.related_scenes.delete @related
      redirect "/scene/#{@scene.id}/related"
    end
    
    post '/scene/:scene_id/related/add', :auth => :approved do |scene_id|
      @scene = Scene[scene_id]
      
      related_id = params[:scene]
      if (!related_id)
        flash[:error] = "No scene selected."
        redirect "/scene/#{@scene.id}/related"
      end
      
      @related = Scene[related_id]
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}/related"
      end
      
      if (!Scenes.can_access_scene?(@user, @related))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}/related"
      end
      
      if (!@related.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scene/#{@scene.id}/related"
      end
      
      @scene.related_scenes.add @related
      redirect "/scene/#{@scene.id}/related"    
    end
  end
end