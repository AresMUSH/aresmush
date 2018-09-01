module AresMUSH
  module Demographics
    class FullCensusRequestHandler
      def handle(request)

        titles = ['Name']
        titles << 'Gender'
        titles.concat(Demographics.all_groups.keys.map { |t| t.titlecase })
        if (Ranks.is_enabled?)
          titles << 'Rank'
        end
        
        chars = Chargen.approved_chars.sort_by { |c| c.name}

        census = []
        
        chars.each do |c|
          char_data = {}
          char_data['Name'] = c.name
          char_data['icon'] = Website.icon_for_char(c)
          Demographics.all_demographics.each do |demographic|
            char_data[demographic.titlecase] = c.demographic(demographic)
          end
          
          Demographics.all_groups.keys.each do |group|
            char_data[group] = c.group(group)
          end
          char_data['Rank'] = c.rank
          census << char_data
        end
        
        {
          titles: titles,
          chars: census
        }
      end
    end
  end
end