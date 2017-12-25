module AresMUSH
  class WebApp
    
    helpers do
      def census_types
        types = Demographics.all_groups.keys
        types << 'gender'
        if (Ranks.is_enabled?)
          types << 'rank'
        end
        types
      end
    end
    
    get '/census/?' do
      @chars = Chargen.approved_chars.sort_by { |c| c.name }
      erb :"census/all"
    end


    get '/census/group/:group/?' do |group|
      if (group == 'Gender')
        @groups = Chargen.approved_chars.group_by { |c| c.demographic(:gender)}
      elsif (group == 'Rank')
        @groups = Chargen.approved_chars.group_by { |c| c.rank}
      else
        @groups = Chargen.approved_chars.group_by { |c| c.group(group)}
      end
      @title = "Characters by #{group.titlecase}"
      erb :"census/group"
    end    

    
    
  end
end