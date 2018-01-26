module AresMUSH
  module Demographics
    class GroupCensusRequestHandler
      def handle(request)
                
        filter = (request.args[:filter] || "").titlecase
        title = "Characters by #{filter}"

        if (filter == 'Gender')
          groups = Chargen.approved_chars.group_by { |c| c.demographic(:gender)}
        elsif (filter == 'Rank')
          groups = Chargen.approved_chars.group_by { |c| c.rank}
        else
          groups = Chargen.approved_chars.group_by { |c| c.group(filter)}
        end
        
        census = []
        groups.sort_by { |g, chars | g || "" }.each do |name, chars|  
          group = {}
          group[:name] = name
          group[:count] = chars.count
          group[:chars] = chars.sort_by { |c| c.name}
            .map { |c| {
             name: c.name,
             icon: WebHelpers.icon_for_char(c),
             groups: c.groups,
             rank: c.rank
          }}
          census << group
        end
                      
        { 
          title: title,
          groups: census
        }
      end
    end
  end
end