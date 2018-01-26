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
            values: data['values'].map { |name, desc| { name: type, value: name, desc: desc } }
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
        
        
       
        {
          abilities: FS3Skills::AbilitiesRequestHandler.new.handle(request),
          skill_limits: Global.read_config('fs3skills', 'max_skills_at_or_above'),
          attr_limits: Global.read_config('fs3skills', 'max_attrs_at_or_above'),
          max_attrs: Global.read_config('fs3skills', 'max_attributes'),
          min_skill_rating: Global.read_config('fs3skills', 'min_skill_rating'),
          max_skill_rating: Global.read_config('fs3skills', 'max_skill_rating'),
          max_attr_rating: Global.read_config('fs3skills', 'max_attr_rating'),
          min_backgrounds: Global.read_config('fs3skills', 'min_backgrounds'),
          max_ap: Global.read_config('fs3skills', 'max_ap'),
          group_options: groups,
        }
      end
    end
  end
end


