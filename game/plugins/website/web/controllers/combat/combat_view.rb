module AresMUSH
  class WebApp
    
    get '/combat/:id/?' do |id|
      @combat = Combat[id]
      erb :"combat/combat"
    end
    
    
    get '/combat/:id/log/?', :auth => :approved do |id|
      @combat = Combat[id]      
      erb :"combat/log"
    end
        
    
  end
end
