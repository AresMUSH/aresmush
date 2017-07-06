module AresMUSH
  class WebApp
    
    get '/scene/pose/:id/edit', :auth => :approved do |id|
      @pose = ScenePose[id]
      if (!@pose.can_edit?(@user))
        flash[:error] = "You are not allowed to do that."
        redirect "/scene/#{@pose.scene.id}"
      end
      
      erb :"/scenes/edit_pose"
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
        char = Character[char_id]
        @pose.update(character: char)
        @pose.scene.participants.add char
      end
      
      flash[:info] = "Updated!"
      redirect "/scene/#{@pose.scene.id}"
    end

  end
end
