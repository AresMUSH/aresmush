module AresMUSH
  module Ranks
    class RankSetCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name, :rank

      def want_command?(client, cmd)
        cmd.root_is?("rank") && cmd.switch_is?("set")
      end

      def crack!
        if (cmd.args =~ /[^\/]+\=.+/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = trim_input(cmd.args.arg1)
          self.rank = titleize_input(cmd.args.arg2)
        else
          self.name = client.name
          self.rank = titleize_input(cmd.args)
        end
      end
      
      def check_can_set
        return nil if client.name == self.name
        return nil if Ranks.can_manage_ranks?(client.char)
        return t('dispatcher.not_allowed')
      end      
      
      def check_chargen_locked
        return nil if Ranks.can_manage_ranks?(client.char)
        Chargen.check_chargen_locked(client.char)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|        
          
          if (self.rank.nil?)
            client.char.rank = rank
            client.char.save
            client.emit_success t('ranks.rank_cleared')
          else
            error = Ranks.check_rank(model, self.rank, Ranks.can_manage_ranks?(client.char))
            if (!error.nil?)
              client.emit_failure error
              return
            end
          
            client.char.rank = rank
            client.char.save
            client.emit_success t('ranks.rank_set', :rank => rank)
          end
        end
      end
    end
  end
end