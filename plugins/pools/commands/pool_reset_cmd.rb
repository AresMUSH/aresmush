module AresMUSH
  module Pools
    class PoolResetCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
          self.name = !cmd.args ? enactor_name : titlecase_arg(cmd.args)          
      end
        
      def check_can_reset
        return nil if enactor_name == self.name
        return nil if Pools.can_manage_pools?(enactor)
        return t('dispatcher.not_allowed')
      end
    
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          Pools.pool_reset(model, enactor, model.room)
      end
    end
  end
end
end