module AresMUSH
  class WebApp
    get '/setup', :auth => :admin do
      @config = Global.read_config("game")
      erb :setup
    end
    
    post '/setup/update', :auth => :admin do
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
      
      output_path = File.join(AresMUSH.game_path, 'config', 'game.yml')
      File.open(output_path, 'w') do |f|
        f.write(template.evaluate(template_data))
      end
      
      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
