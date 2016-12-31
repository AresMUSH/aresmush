module AresMUSH
  module Ranks
    class RanksCmd
      include CommandHandler
      
      attr_accessor :name
            
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        if (!self.name)
          title = t('ranks.all_ranks_title', :group => Ranks.rank_group)
          client.emit BorderedDisplay.list Global.read_config("ranks", "ranks").keys, title
          return
        end

        config = Ranks.group_rank_config(self.name)
        if (!config)
          client.emit_failure t('ranks.no_ranks_for_group', :group => self.name)
          return
        end

        template = RanksTemplate.new config, self.name
        client.emit template.render
      end
    end
  end
end