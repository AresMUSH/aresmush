module AresMUSH
  class WebApp

    get '/combat/:id/manage/?', :auth => :approved do |id|
      @combat = Combat[id]
      if (!@combat)
        flash[:error] = "That combat doesn't exist."
        redirect "/combat"
      end
      
      if (@combat.organizer != @user && !is_admin?)
        flash[:error] = "Only the combat organizer can setup combat."
        redirect "/combat/#{id}"
      end
      
      erb :"combat/manage"
    end    
  end
end
