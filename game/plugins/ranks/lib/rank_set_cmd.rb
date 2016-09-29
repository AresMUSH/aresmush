module AresMUSH
  module Ranks
    class RankSetCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name, :rank

      def crack!
        if (cmd.args =~ /[^\/]+\=.+/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = trim_input(cmd.args.arg1)
          self.rank = titleize_input(cmd.args.arg2)
        else
          self.name = enactor_name
          self.rank = titleize_input(cmd.args)
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
        ClassTargetFinder.with_a_character(self.name, client) do |model|        
          
          if (!self.rank)
            enactor.rank = rank
            enactor.save
            client.emit_success t('ranks.rank_cleared')
          else
            error = Ranks.check_rank(model, self.rank, Ranks.can_manage_ranks?(enactor))
            if (error)
              client.emit_failure error
              return
            end
          
            enactor.rank = rank
            enactor.save
            client.emit_success t('ranks.rank_set', :rank => rank)
          end
        end
      end
    end
  end
end