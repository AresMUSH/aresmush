module AresMUSH
  class WebApp
    get '/admin/fs3_skills/?', :auth => :admin do
      
      @action_skills = Global.read_config("fs3skills", "action_skills").to_a
      count = @action_skills.count
      more = [ 0, 15 - count].max

      more.times.each do |m|
        @action_skills << { 'name' => "", 'linked_attr' => "", 'desc' => ""}
      end
      
      @attrs = Global.read_config("fs3skills", "attributes").to_a
      count = @attrs.count
      more = [ 0, 10 - count].max

      more.times.each do |m|
        @attrs << { 'name' => "", 'desc' => ""}
      end
      
      @default_attr = Global.read_config("fs3skills", "default_linked_attr")
      
      @langs = Global.read_config("fs3skills", "languages").to_a
      count = @langs.count
      more = [ 0, 10 - count].max

      more.times.each do |m|
        @langs << { 'name' => "", 'desc' => ""}
      end
      
      @starting_langs = Global.read_config("fs3skills", "starting_languages").join(",")
      
      erb :"fs3/config_skills"
    end
    
    post '/admin/fs3_skills/update', :auth => :admin do
      
      action_skills = []
      15.times.each do |i|
        if (!params["action-name-#{i}"].blank?)
          skill =  { 'name' => params["action-name-#{i}"],
                             'linked_attr' => params["action-linked-#{i}"],
                             'desc' => params["action-desc-#{i}"]}
          if (!params["action-spec-#{i}"].blank?)
            skill['specialties'] = params["action-spec-#{i}"].split(',').map { |s| s.strip.titleize}
          end
          action_skills << skill
        end
      end
      
      config = { 
        "fs3skills" => {
          "action_skills" => action_skills
        }
        
      }
      output_path = File.join(AresMUSH.plugin_path, 'fs3skills', 'config_fs3skills_action.yml')
      write_config_file output_path, config.to_yaml
      
      
      attributes = []
      10.times.each do |i|
        if (!params["attr-name-#{i}"].blank?)
          att =  { 'name' => params["attr-name-#{i}"],
                             'desc' => params["attr-desc-#{i}"]}
          attributes << att
        end
      end
      
      config = { 
        "fs3skills" => {
          "attributes" => attributes,
          "default_linked_attr" => params["default-attr"]
        }
        
      }
      output_path = File.join(AresMUSH.plugin_path, 'fs3skills', 'config_fs3skills_attrs.yml')
      write_config_file output_path, config.to_yaml
      
      
      langs = []
      10.times.each do |i|
        if (!params["lang-name-#{i}"].blank?)
          l =  { 'name' => params["lang-name-#{i}"],
                             'desc' => params["lang-desc-#{i}"]}
          langs << l
        end
      end
      
      config = { 
        "fs3skills" => {
          "languages" => langs,
          "starting_languages" => params['starting-langs'].split(',')
        }
        
      }
      output_path = File.join(AresMUSH.plugin_path, 'fs3skills', 'config_fs3skills_langs.yml')
      write_config_file output_path, config.to_yaml
      

      flash[:info] = "Saved!"
      Manage.reload_config
      
      redirect '/admin'
    end
        
  end
end
