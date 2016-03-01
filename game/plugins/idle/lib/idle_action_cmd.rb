module AresMUSH

  module Idle
    class IdleActionCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :action

      def initialize
        self.required_args = ['name', 'action']
        self.help_topic = 'idle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("idle") && cmd.switch_is?("action")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.action = titleize_input(cmd.args.arg2)
      end

      def check_can_manage
        return nil if Idle.can_idle_sweep?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        queue = client.program[:idle_queue]
        return t('idle.idle_not_started') if !queue
        return nil
      end
      
      def check_action
        actions = [ 'Nothing', 'Roster', 'Destroy', 'Dead', 'Gone', "Npc", "Warn" ]
        return t('idle.invalid_action', :actions => actions.join(" ")) if !actions.include?(self.action)
        return nil
      end
            
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          client.program[:idle_queue][model.id] = self.action
          client.emit_success t('idle.idle_action_set', :name => self.name, :action => self.action)
        end
      end
    end
  end
end
