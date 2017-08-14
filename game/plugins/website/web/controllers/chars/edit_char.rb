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
      relationships = {}
      
      params.each do |k, v|
        if (k.start_with?('profiletitle-') && !v.blank?)
          name = k.after('-')
          profile[v] = params["profile-#{name}"]
        elsif (k.start_with?('demo-'))
          name = k.after('-')
          demographics[name] = v
        elsif (k.start_with?('relationname-') && !v.blank?)
          name = k.after('-')
          relationships[v] = { 
            'category' => params["relationcat-#{name}"],
            'relationship' => params["relationdetail-#{name}"]
          }
        end
      end
      
      demographics.each do |name, value|
        @char.update_demographic name, value
      end
      
      @char.update(profile: profile)
      @char.update(relationships: relationships)
      @char.update(profile_image: params[:profileimage])
      @char.update(profile_gallery: params[:gallery])
      
      flash[:info] = "Character updated!"
      redirect "/char/#{id}"
    end
  end
end