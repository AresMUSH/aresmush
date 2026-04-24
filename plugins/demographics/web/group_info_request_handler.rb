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
            values: (data['values'] || {}).map { |name, desc| { name: type.titleize, value: name, desc: desc } },
            freeform: !data['values']
          }
        end
        
        if (Ranks.is_enabled?)
          Ranks.build_rank_group_data(groups)
        end
        
        groups
      end
    end
  end
end