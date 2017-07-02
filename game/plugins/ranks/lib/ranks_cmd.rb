module AresMUSH
  module Ranks
    class RanksCmd
      include CommandHandler
      
      attr_accessor :name
            
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle
        if (!self.name)
          title = t('ranks.all_ranks_title', :group => Ranks.rank_group)
          template = BorderedListTemplate.new Global.read_config("ranks", "ranks").keys, title
          client.emit template.render
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