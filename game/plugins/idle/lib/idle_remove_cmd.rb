module AresMUSH

  module Idle
    class IdleRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'idle'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end

      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        queue = client.program[:idle_queue]
        return t('idle.idle_not_started') if !queue
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          client.program[:idle_queue].delete model.id
          client.emit_success t('idle.idle_removed', :name => self.name)
        end
      end
    end
  end
end
