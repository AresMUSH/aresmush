module AresMUSH
  module Demographics
    class GroupCensusRequestHandler
      def handle(request)
                
        filter = (request.args[:filter] || "").titlecase
        title = t('demographics.group_census_title', :name => filter)

        if (filter == 'Gender')
          groups = Chargen.approved_chars.group_by { |c| c.demographic(:gender)}
        elsif (filter == 'Rank')
          groups = Chargen.approved_chars.group_by { |c| c.rank}
        else
          groups = Chargen.approved_chars.group_by { |c| c.group(filter)}
        end
        
        census = []
        groups.select { |g| !g.blank? }.sort_by { |g, chars | g || "" }.each do |name, chars|  
          group = {}
          group[:name] = name
          group[:count] = chars.count
          group[:chars] = chars.sort_by { |c| c.name}
            .map { |c| {
             mushname: c.name,
             name: Demographics.name_and_nickname(c),
             icon: Website.icon_for_char(c),
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