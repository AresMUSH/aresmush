module AresMUSH
  module Ranks
    class RankSetCmd
      include CommandHandler
      
      attr_accessor :name, :rank

      def parse_args
        # Admin version 
        if (Ranks.can_manage_ranks?(enactor) && cmd.args =~ /[^\=]+\=(.+)?/)
          self.name = trim_arg(cmd.args.before("="))
          self.rank = titlecase_arg(cmd.args.after("=") || "")
        else
          self.name = enactor_name
          self.rank = titlecase_arg(cmd.args || "")
        end
      end
      
      def check_can_set
        return nil if enactor_name == self.name
        return nil if Ranks.can_manage_ranks?(enactor)
        return t('dispatcher.not_allowed')
      end      
      
      def check_chargen_locked
        return nil if Ranks.can_manage_ranks?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|        
          
          if (self.rank.blank?)
            model.update(ranks_rank: nil)
            client.emit_success t('ranks.rank_cleared')
          else
            error = Ranks.set_rank(model, self.rank, Ranks.can_manage_ranks?(enactor))
            if (error)
              client.emit_failure error
            else
              client.emit_success t('ranks.rank_set', :rank => rank)
            end
          end
        end
      end
    end
  end
end