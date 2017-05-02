module AresMUSH

  module Idle
    class IdleActionCmd
      include CommandHandler
      
      attr_accessor :name, :action

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.action = titlecase_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.name, self.action ],
          help: 'idle'
        }
      end
      
      def check_roster_enabled
        return t('idle.roster_disabled') if (!Idle.roster_enabled? && self.action == "Roster")
        return nil
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
      
      def check_action
        actions = [ 'Nothing', 'Reset', 'Roster', 'Destroy', 'Dead', 'Gone', "Npc", "Warn" ]
        return t('idle.invalid_action', :actions => actions.join(" ")) if !actions.include?(self.action)
        return nil
      end
            
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          client.program[:idle_queue][model.id] = self.action
          client.emit_success t('idle.idle_action_set', :name => self.name, :action => self.action)
        end
      end
    end
  end
end
