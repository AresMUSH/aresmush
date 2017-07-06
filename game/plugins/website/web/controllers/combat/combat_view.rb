module AresMUSH
  class WebApp
    
    get '/combat/:id' do |id|
      @combat = Combat[id]
      erb :"combat/combat"
    end
    
  end
end
