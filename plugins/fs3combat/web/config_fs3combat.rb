module AresMUSH
  class WebApp
    get '/admin/fs3_combat/?', :auth => :admin do
      
      file_path = File.join(AresMUSH.plugin_path, 'fs3combat', 'config_fs3combat_skills.yml')
      config_yaml = AresMUSH::YamlExtensions.yaml_hash(file_path)
      @skills = config_yaml['fs3combat']
            
      erb :"combat/config_combat"
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
      output_path = File.join(AresMUSH.plugin_path, 'fs3combat', 'config_fs3combat_skills.yml')
      write_config_file output_path, config.to_yaml
      
      
      flash[:info] = "Saved!"
      
      reload_config
      
      redirect '/admin'
    end
        
  end
end
