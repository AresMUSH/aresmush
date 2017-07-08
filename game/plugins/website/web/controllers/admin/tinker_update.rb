module AresMUSH
  class WebApp
    
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
