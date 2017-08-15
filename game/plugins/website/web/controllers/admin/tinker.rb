module AresMUSH
  class WebApp
    
    get '/admin/tinker/?', :auth => :admin do
      @code = File.read(tinker_cmd_path)
      erb :"admin/tinker"
    end
    
    post '/admin/tinker/reset', :auth => :admin do
      flash[:info] = "The tinker code has been reset to its default value."

      reset_path = File.join(AresMUSH.game_path, 'plugins', 'tinker', 'default_tinker.txt')
      FileUtils.cp reset_path, tinker_cmd_path
      begin
        Global.plugin_manager.unload_plugin("tinker")
      rescue SystemNotFoundException
        # Swallow this error.  Just means you're loading a plugin for the very first time.
      end
      Global.plugin_manager.load_plugin("tinker")
      redirect '/admin/tinker'
    end
    
    post '/admin/tinker/update', :auth => :admin do

      begin
      
        File.open(tinker_cmd_path, 'w') do |f|
          f.write params[:contents]
        end

        begin
          Global.plugin_manager.unload_plugin("tinker")
        rescue SystemNotFoundException
          # Swallow this error.  Just means you're loading a plugin for the very first time.
        end

        Global.plugin_manager.load_plugin("tinker")
        flash[:info] = "The tinker code has been updated.  You can now run it in-game with the 'tinker' command."
        
      rescue Exception => ex
        flash[:error] = "There was a problem with the tinker code: #{ex}"
      end
      
      redirect '/admin/tinker'
    end
    
  end
end
