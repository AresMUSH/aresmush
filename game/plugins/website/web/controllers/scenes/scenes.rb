module AresMUSH
  class WebApp
    helpers do
      def can_access_scene?(scene)
        Scenes.can_access_scene?(@user, scene)
      end
      
      def scenes_of_type(type)
        @scenes.select { |s| s.scene_type == type }
      end
      
      def show_related_scene_comma(index)
        count = @scene.related_scenes.count
        count > 1 && index != count - 1
      end
    end
    
    get '/scenes/?' do
      @page = params[:page] ? params[:page].to_i : 1
      @tab = params[:tab] || "Recent"
      
      list = Scene.all.select { |s| s.shared }.sort_by { |s| s.date_shared || s.created_at }.reverse
      if (@tab == "Recent")
        list = list[0..15]
      else
        list = list.select { |s| s.scene_type == @tab }
      end
      
      paginator = AresMUSH::Paginator.paginate list, @page, 25
      @scenes = paginator.items
      @pages = paginator.total_pages
      
      if (paginator.out_of_bounds?)
        flash[:error] = "There aren't that many pages."
        redirect "/scenes"
      end
      @scene_types = Scenes.scene_types
      erb :"scenes/scenes_index"
    end
    
    get '/scene/:id/?' do |id|
      @scene = Scene[id]
      
      if (!@scene || !@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end

      @page_title = "#{@scene.date_title} - #{game_name}"
      
      erb :"scenes/scene"
    end
 
  end
end
