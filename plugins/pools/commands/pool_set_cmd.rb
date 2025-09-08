module AresMUSH
  module Pools
    class PoolSetCmd
      include CommandHandler
      
      attr_accessor :name, :pool, :reason

      def parse_args
        # Admin version
        if (Pools.can_manage_pools?(enactor)) && (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.name = titlecase_arg(args.arg1)
          self.pool = integer_arg(args.arg2)
          self.reason = titlecase_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = enactor_name
          self.pool = integer_arg(args.arg1)
          self.reason = titlecase_arg(args.arg2)
        end
     end

      def required_args
        [ self.name, self.pool, self.reason ]
      end

      def check_can_set
        return nil if enactor_name == self.name
        return nil if Pools.can_manage_pools?(enactor)
        return t('dispatcher.not_allowed')
      end
        
      def check_pools
        return t('pools.pool_empty') if enactor.pool < Global.read_config("pools", "min_pool")
        return t('pools.pool_full') if enactor.pool > Global.read_config("pools", "max_pool")
        return nil
      end


      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          Pools.pool_set(model, enactor_name, self.pool, reason, model.room)
      end
    end
   end
  end
end