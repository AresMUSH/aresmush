module AresMUSH
  class WebApp
    helpers do
      def tinker_cmd_path
        File.join(AresMUSH.game_path, 'plugins', 'tinker', 'lib', 'tinker_cmd.rb')
      end
    end
    
    get '/admin', :auth => :admin do
      @reboot_required = File.exist?('/var/run/reboot-required')
      erb :"admin/admin_index"
    end
    
    get '/admin/shutdown', :auth => :admin do
      path = File.join( AresMUSH.game_path, "..", "bin", "killares" )
      `#{path}`
      "" # We'll never return
    end
    
    get '/admin/tinker', :auth => :admin do
      @code = File.read(tinker_cmd_path)
      erb :"admin/tinker"
    end
    
    post '/admin/tinker/reset', :auth => :admin do
      flash[:info] = "The tinker code has been reset to its default value."

      reset_path = File.join(AresMUSH.game_path, 'plugins', 'tinker', 'default_tinker.txt')
      FileUtils.cp reset_path, tinker_cmd_path
      Global.plugin_manager.unload_plugin("tinker")
      Global.plugin_manager.load_plugin("tinker")
      redirect '/admin/tinker'
    end
    
    post '/admin/tinker/update', :auth => :admin do

      flash[:info] = "The tinker code has been updated.  You can now run it in-game with the 'tinker' command."
      
      File.open(tinker_cmd_path, 'w') do |f|
        f.write params[:tinkerCode]
      end
      Global.plugin_manager.unload_plugin("tinker")
      Global.plugin_manager.load_plugin("tinker")
      
      redirect '/admin/tinker'
    end
    
  end
end
