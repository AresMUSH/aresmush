module AresMUSH
  class WebApp
    helpers do
      def can_access_scene?(scene)
        Scenes.can_access_scene?(@user, scene)
      end
      
      def scenes_of_type(type)
        @scenes.select { |s| s.scene_type == type }
      end
    end
    
    get '/scenes' do
      @scenes = Scene.all.select { |s| s.shared }.sort_by { |s| s.created_at }.reverse
      @scene_types = Scenes.scene_types
      erb :"scenes/index"
    end
    
    get '/scene/:id' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/log"
    end
 
  end
end
