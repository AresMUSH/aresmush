module AresMUSH
  class WebApp
    get '/admin', :auth => :admin do
      erb :admin_index      
    end
    
    get '/shutdown', :auth => :admin do
      path = File.join( AresMUSH.game_path, "..", "bin", "killares" )
      `#{path}`
      "" # We'll never return
    end
    
    get '/tinker', :auth => :admin do
      @code = File.read(File.join( AresMUSH.game_path, 'plugins', 'tinker', 'lib', 'tinker_cmd.rb'))
      erb :tinker
    end
    
    post '/tinker/update', :auth => :admin do
      File.open(File.join( AresMUSH.game_path, 'plugins', 'tinker', 'lib', 'tinker_cmd.rb'), 'w') do |f|
        f.write params[:tinkerCode]
      end
      Global.plugin_manager.unload_plugin("tinker")
      Global.plugin_manager.load_plugin("tinker")
      
      redirect '/admin'
    end
    
  end
end
