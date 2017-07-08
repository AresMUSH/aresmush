module AresMUSH
  class WebApp
    
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
    
  end
end
