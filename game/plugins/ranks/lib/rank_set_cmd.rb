module AresMUSH
  module Ranks
    class RankSetCmd
      include CommandHandler
      
      attr_accessor :name, :rank

      def parse_args
        if (cmd.args =~ /[^\/]+\=.+/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = trim_arg(args.arg1)
          self.rank = titlecase_arg(args.arg2)
        else
          self.name = enactor_name
          self.rank = titlecase_arg(cmd.args)
        end
      end
      
      def check_can_set
        return nil if enactor_name == self.name
        return nil if Ranks.can_manage_ranks?(enactor)
        return t('dispatcher.not_allowed')
      end      
      
      def check_chargen_locked
        return nil if Ranks.can_manage_ranks?(enactor)
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|        
          
          if (!self.rank)
            enactor.update(ranks_rank: rank)
            client.emit_success t('ranks.rank_cleared')
          else
            error = Ranks.check_rank(model, self.rank, Ranks.can_manage_ranks?(enactor))
            if (error)
              client.emit_failure error
              return
            end
          
            model.update(ranks_rank: rank)
            client.emit_success t('ranks.rank_set', :rank => rank)
          end
        end
      end
    end
  end
end