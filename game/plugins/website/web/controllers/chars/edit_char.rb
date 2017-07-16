module AresMUSH
  class WebApp
    get '/char/:id/edit', :auth => :approved do |id|
      @char = Character[id]
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end

      erb :"chars/edit_char"
    end
    
    post '/char/:id/edit', :auth => :approved do |id|
      @char = Character[id]
      
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      if (!can_manage_char?(@char))
        flash[:error] = "You are not allowed to do that."
        redirect "/chars"
      end
      
      if (!@char.is_approved?)
        flash[:error] = "You can only edit approved characters."
        reedirect "/char/#{id}"
      end
            
      demographics = {}
      profile = {}
      
      params.each do |k, v|
        if (k.start_with?('profiletitle-') && !v.blank?)
          name = k.after('-')
          profile[v] = params["profile-#{name}"]
        end
        
        if (k.start_with?('demo-'))
          name = k.after('-')
          demographics[name] = v
        end
      end
      
      demographics.each do |name, value|
        @char.update_demographic name, value
      end
      
      @char.update(profile: profile)
      
      
      flash[:info] = "Character updated!"
      redirect "/char/#{id}"
    end
  end
end