module AresMUSH
  class WebApp
    
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

  end
end
