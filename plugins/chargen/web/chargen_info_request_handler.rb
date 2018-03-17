module AresMUSH
  module Chargen
    class ChargenInfoRequestHandler
      def handle(request)
        group_config = Global.read_config('demographics', 'groups')
        
        groups = {}
        group_config.each do |type, data|
          groups[type.downcase] = {
            name: type,
            desc: data['desc'],
            values: (data['values'] || {}).map { |name, desc| { name: type, value: name, desc: desc } },
            freeform: !data['values']
          }
        end
        
        if (Ranks.is_enabled?)
          ranks = []
          
          group_config[Ranks.rank_group]['values'].each do |k, v|
            Ranks.allowed_ranks_for_group(k).each do |r|
              ranks << { name: 'Rank', value: r }
            end
          end
          
          groups['rank'] = {
            name: 'Rank',
            desc: 'Military rank.',
            values: ranks
          }
        end
        
        
        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::ChargenInfoRequestHandler.new.handle(request)
        else
          fs3 = nil
        end
        
        {
          fs3: fs3,
          group_options: groups,
        }
      end
    end
  end
end


