module AresMUSH
  module Pools
    class PoolDesperateCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
          self.name = !cmd.args ? enactor_name : titlecase_arg(cmd.args)          
      end
        
      def check_can_desperate
        return nil if enactor_name == self.name
        return nil if Pools.can_manage_pools?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if model.pools_pool < Global.read_config("pools", "min_pool_spend")
             message = t('pools.pool_empty', :pool_name_plural => Global.read_config("pools", "pool_name_plural") )
             client.emit_ooc message
          else
             Pools.pool_desperate(model, enactor, model.room)
          end
        end
      end
    end
  end
end