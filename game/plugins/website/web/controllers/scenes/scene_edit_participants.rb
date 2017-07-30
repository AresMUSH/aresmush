module AresMUSH
  class WebApp
        
    get '/scene/:id/participants', :auth => :approved do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      @available_chars = AresMUSH::Character.all.select { |c| c.is_approved? }.sort_by { |c| c.name }
      erb :"scenes/edit_participants"
    end
    
    get '/scene/:scene_id/participants/delete/:char_id', :auth => :approved do |scene_id, char_id|
      @scene = Scene[scene_id]
      @char = Character[char_id]
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}"
      end
      
      @scene.participants.delete @char
      redirect "/scene/#{@scene.id}/participants"
    end
    
    post '/scene/:scene_id/participants/add', :auth => :approved do |scene_id|
      @scene = Scene[scene_id]
      
      char_id = params[:character]
      if (!char_id)
        flash[:error] = "No character selected."
        redirect "/scene/#{@scene.id}/participants"
      end
      
      @char = Character[char_id]
      if (!Scenes.can_access_scene?(@user, @scene))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@scene.id}"
      end
      
      @scene.participants.add @char
      redirect "/scene/#{@scene.id}/participants"
    end
    
  end
end
