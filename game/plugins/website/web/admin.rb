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
  end
end
