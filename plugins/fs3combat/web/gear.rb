module AresMUSH
  class WebApp
        
    get '/combat/gear/?' do
      erb :"combat/gear"
    end
    
    get '/combat/gear/:type/?' do |type|
      @name = params[:name]
      
      if (@name.blank?)
        flash[:error] = "Invalid gear type."
        redirect "/combat/gear"
      end
      
      case (type || "").downcase
      when "weapon"
        @data = FS3Combat.weapon(@name)
      when "armor"
        @data = FS3Combat.armor(@name)
      when "vehicle"
        @data = FS3Combat.vehicle(@name)
      else
        flash[:error] = "Invalid gear type."
        redirect "/combat/gear"
      end
      
      erb :"combat/gear_detail"
    end
    
  end
end
