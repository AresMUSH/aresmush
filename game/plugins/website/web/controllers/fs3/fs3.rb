module AresMUSH
  class WebApp
    
    get '/fs3/skills/?' do      
      erb :"fs3/skills"
    end
    
    get '/fs3/gear/?' do
      erb :"fs3/gear"
    end
    
    get '/fs3/gear/:type/?' do |type|
      @name = params[:name]
      
      if (@name.blank?)
        flash[:error] = "Invalid gear type."
        redirect "/fs3/gear"
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
        redirect "/fs3/gear"
      end
      
      erb :"fs3/gear_detail"
    end
    
  end
end
