module AresMUSH
  class WebApp
    get '/admin/game_info/?', :auth => :admin do
      @config = Global.read_config("game")
      erb :"admin/game_info"
    end
    
    post '/admin/game_info/update', :auth => :admin do
      template_data = 
      {
        "mush_name" => params[:name],
        "category" => params[:category],
        "game_desc" => format_input_for_mush(params[:description]),
        "website" => params[:website],
        "public_game" => params[:public]
      }
  
      template_path = File.join(AresMUSH.game_path, '..', 'install', 'templates', 'game.yml.erb')
      template = Erubis::Eruby.new(File.read(template_path, :encoding => "UTF-8"))
      
      write_config_file(File.join(AresMUSH.game_path, 'config', 'game.yml'), 
         template.evaluate(template_data))
      
      flash[:info] = "Saved!"
      Manage.reload_config
      
      redirect '/admin'
    end
        
  end
end
