module AresMUSH
  class WebApp
    
    get '/scenes/create/?', :auth => :approved do 
      @plots = Plot.all.to_a.sort_by { |p| p.id }.reverse
      @available_chars = AresMUSH::Character.all.select { |c| c.is_approved? }.sort_by { |c| c.name }
      @available_scenes = Scene.all.to_a.select { |s| s.shared }.sort_by { |s| s.icdate }.reverse
      
      erb :"scenes/create_scene"
    end
    
    post '/scenes/create', :auth => :approved do
      
      plot = params[:plot]
      
      @scene = Scene.create(
      location: params[:location],
      summary: params[:summary],
      scene_type: params[:scene_type],
      title: params[:title],
      icdate: params[:icdate],
      shared: true,
      completed: true,
      plot: plot.blank? ? nil : Plot[plot],
      owner: @user
      )
            
      participant_names = (params[:participants] || "").split(" ").uniq    
      participant_names.each do |p|
        participant = Character.find_one_by_name(p.strip)
        if (participant)
          @scene.participants.add participant
        end
      end
      
      related_scene_ids = (params[:related] || "").split(" ").uniq
      
      # New additions
      (related_scene_ids).each do |s|
        related = Scene[s]
        if (related)
          SceneLink.create(log1: @scene, log2: related)
        end
      end      
      
      log = SceneLog.create(scene: @scene, log: params[:log])
      @scene.update(scene_log: log)
      
      flash[:info] = "Scene created!"
      redirect "/scene/#{@scene.id}"
    end
    
    
  end
end
