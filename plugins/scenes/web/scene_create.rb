module AresMUSH
  class WebApp
    
    get '/scenes/create/?', :auth => :approved do 
      @plots = Plot.all.to_a.sort_by { |p| p.id }
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
            
      @scene.participants.add @user
      
      log = SceneLog.create(scene: @scene, log: params[:log])
      @scene.update(scene_log: log)
      
      flash[:info] = "Scene created!"
      redirect "/scene/#{@scene.id}"
    end
    
    
  end
end
