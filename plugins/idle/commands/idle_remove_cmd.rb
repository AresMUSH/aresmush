module AresMUSH

  module Idle
    class IdleRemoveCmd
      include CommandHandler
      
      attr_accessor :names
      
      def parse_args
        self.names = list_arg(cmd.args)
      end
      
      def required_args
        [ self.names ]
      end
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        return t('idle.idle_not_started') if !client.program[:idle_queue]
        return nil
      end
      
      def handle
        self.names.each do |name|
          ClassTargetFinder.with_a_character(name, client, enactor) do |model|
            client.program[:idle_queue].delete model.id
            client.emit_success t('idle.idle_removed', :name => model.name)
          end
        end
      end
    end
  end
end
