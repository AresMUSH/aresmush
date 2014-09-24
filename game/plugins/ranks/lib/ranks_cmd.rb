module AresMUSH
  module Ranks
    class RanksCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name
            
      def want_command?(client, cmd)
        cmd.root_is?("ranks") 
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        if (self.name.nil?)
          title = t('ranks.all_ranks_title', :group => Ranks.rank_group)
          client.emit BorderedDisplay.list Global.config["ranks"]["ranks"].keys, title
          return
        end

        config = Ranks.group_rank_config(self.name)
        if (config.nil?)
          client.emit_failure t('ranks.no_ranks_for_group', :group => self.name)
          return
        end

        title = t('ranks.ranks_title', :group => self.name)
        list = [ "%xh#{title}%xn" ]
        config.each do |rank_type, type_config|
          list << "%R%xh#{rank_type}%xn"
          type_config.each do |rank, allowed|
            color = allowed ? "" : "%xh%xx"
            list << "#{color}#{rank}%xn"
          end
        end
        
        list << ""
        list << t('ranks.ranks_footer')
        
        client.emit BorderedDisplay.list list
      end
    end
  end
end