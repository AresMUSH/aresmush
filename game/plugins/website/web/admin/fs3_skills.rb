module AresMUSH
  class WebApp
    get '/admin/fs3_skills', :auth => :admin do
      
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
      
      
      @langs = Global.read_config("fs3skills", "languages").to_a
      count = @langs.count
      more = [ 0, 10 - count].max

      more.times.each do |m|
        @langs << { 'name' => "", 'desc' => ""}
      end
      
      
      erb :"admin/fs3_skills"
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
      output_path = File.join(AresMUSH.game_path, 'plugins', 'fs3skills', 'config_fs3skills_action.yml')
      write_config_file output_path, config.to_yaml
      

      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
