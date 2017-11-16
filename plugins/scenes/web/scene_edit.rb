module AresMUSH
  class WebApp
    
    get '/scene/:id/edit/?', :auth => :approved do |id|
      @scene = Scene[id]
      @plots = Plot.all.to_a.sort_by { |p| p.id }
      @log = @scene.scene_log
      @available_chars = AresMUSH::Character.all.select { |c| c.is_approved? }.sort_by { |c| c.name }
      @available_scenes = Scene.all.to_a.select { |s| s.shared && s.id != id }.sort_by { |s| s.icdate }.reverse
      
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

      plot = params[:plot]
      if (!plot.blank?)
        @scene.update(plot: Plot[plot])
      end
            
      participant_names = (params[:participants] || "").split(" ").uniq
      @scene.participants.replace []
      
      participant_names.each do |p|
        participant = Character.find_one_by_name(p.strip)
        if (participant)
          @scene.participants.add participant
        end
      end
      
      related_scene_ids = (params[:related] || "").split(" ").uniq
      already_related = @scene.related_scenes.map { |s| s.id }
      
      # New additions
      (related_scene_ids - already_related).each do |s|
        related = Scene[s]
        if (related)
          SceneLink.create(log1: @scene, log2: related)
        end
      end
      
      # Removed
      (already_related - related_scene_ids).each do |s|
        link = @scene.find_link(Scene[s])
        if (link)
          link.delete
        end
      end
      
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
