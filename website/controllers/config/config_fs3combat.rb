module AresMUSH
  class WebApp
    get '/admin/fs3_combat/?', :auth => :admin do
      
      @skills = {
        "treat_skill" => Global.read_config("fs3combat", "treat_skill"),
        "healing_skill" => Global.read_config("fs3combat", "healing_skill"),
        "recovery_skill" => Global.read_config("fs3combat", "recovery_skill"),
        "initiative_skill" => Global.read_config("fs3combat", "initiative_skill"),
        "composure_skill" => Global.read_config("fs3combat", "composure_skill"),
        "default_defense_skill" => Global.read_config("fs3combat", "default_defense_skill")
      }
            
      erb :"admin/fs3_combat"
    end
    
    post '/admin/fs3_combat/update', :auth => :admin do
      skills = {}
      params.each do |k, v|
        if (k.start_with?("skill-"))
          skills[k.after('-')] = v
        end
      end
      
      config = { 
        "fs3combat" => skills
        
      }
      output_path = File.join(AresMUSH.game_path, 'plugins', 'fs3combat', 'config_fs3combat_skills.yml')
      write_config_file output_path, config.to_yaml
      
      
      flash[:info] = "Saved!"
      Manage.reload_config
      
      redirect '/admin'
    end
        
  end
end
