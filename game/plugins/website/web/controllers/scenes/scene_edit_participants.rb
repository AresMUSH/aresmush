module AresMUSH
  class WebApp
        
    get '/scene/:id/participants' do |id|
      @scene = Scene[id]
      
      if (!@scene.shared)
        flash[:error] = "That scene has not been shared."
        redirect "/scenes"
      end
      
      erb :"scenes/edit_participants"
    end
    
  end
end
