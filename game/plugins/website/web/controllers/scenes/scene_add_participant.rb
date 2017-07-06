module AresMUSH
  class WebApp
    
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
