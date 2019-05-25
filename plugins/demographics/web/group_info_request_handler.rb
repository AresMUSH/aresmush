module AresMUSH
  module Demographics
    class GroupInfoRequestHandler
      def handle(request)
                
        group_config = Global.read_config('demographics', 'groups')
        
        groups = {}
        group_config.each do |type, data|
          groups[type.downcase] = {
            name: type,
            desc: data['desc'],
            wiki: data['wiki'].blank? ? nil : data['wiki'],
            values: (data['values'] || {}).sort_by { |name, desc| name }.map { |name, desc| { name: type.titleize, value: name, desc: desc } },
            freeform: !data['values']
          }
        end
        
        if (Ranks.is_enabled?)
          ranks = []
          
          group_config[Ranks.rank_group]['values'].each do |k, v|
            Ranks.allowed_ranks_for_group(k).each do |r|
              ranks << { name: 'Rank', value: r, desc: k }
            end
          end
          
          groups['rank'] = {
            name: 'Rank',
            desc: Global.read_config('chargen', 'rank_blurb'),
            values: ranks
          }
        end
        
        groups
      end
    end
  end
end