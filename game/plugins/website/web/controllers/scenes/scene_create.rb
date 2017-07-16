module AresMUSH
  class WebApp
    
    get '/scenes/create', :auth => :approved do 
      erb :"scenes/create_scene"
    end
    
    post '/scenes/create', :auth => :approved do
      
      @scene = Scene.create(
      location: params[:location],
      summary: params[:summary],
      scene_type: params[:scene_type],
      title: params[:title],
      icdate: params[:icdate],
      shared: true,
      completed: true,
      owner: @user
      )
      
      @scene.participants.add @user
      
      SceneLog.create(scene: @scene, log: params[:log])
      
      flash[:info] = "Scene created!"
      redirect "/scene/#{@scene.id}"
    end
    
    
  end
end
