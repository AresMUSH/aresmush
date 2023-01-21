module AresMUSH

  module Idle
    class IdleResetCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          model.update(idle_state: nil)
          model.update(is_npc: false)
          
          client.emit_success t('idle.idle_status_reset', :name => self.name)
        end
      end
    end
  end
end
