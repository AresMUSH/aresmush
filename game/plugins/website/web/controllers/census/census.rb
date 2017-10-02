module AresMUSH
  class WebApp
    
    helpers do
      def census_types
        [ 'gender', 'colony', 'faction', 'position', 'department', 'rank' ]
      end
    end
    
    get '/census/?' do
      @chars = Idle.active_chars.sort_by { |c| c.name }
      erb :"census/all"
    end


    get '/census/gender/?' do
      @groups = Idle.active_chars.group_by { |c| c.demographic(:gender)}
      @title = "Characters by Gender"
      erb :"census/group"
    end

    get '/census/colony/?' do
      @groups = Idle.active_chars.group_by { |c| c.group('Colony')}
      @title = "Characters by Colony"
      erb :"census/group"
    end
    
    get '/census/faction/?' do
      @groups = Idle.active_chars.group_by { |c| c.group('Faction')}
      @title = "Characters by Faction"
      erb :"census/group"
    end
    
    get '/census/position/?' do
      @groups = Idle.active_chars.group_by { |c| c.group('Position')}
      @title = "Characters by Position"
      erb :"census/group"
    end

    get '/census/department/?' do
      @groups = Idle.active_chars.group_by { |c| c.group('Department')}
      @title = "Characters by Department"
      erb :"census/group"
    end

    get '/census/rank/?' do
      @groups = Idle.active_chars.group_by { |c| c.rank}
      @title = "Characters by Rank"
      erb :"census/group"
    end
    
    
  end
end