module AresMUSH

  module Idle
    class IdleActionCmd
      include CommandHandler
      
      attr_accessor :name, :action

      def parse_args
        if (cmd.switch_is?("action"))
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.action = titlecase_arg(args.arg2)
        else
          self.name = titlecase_arg(cmd.args)
          self.action = titlecase_arg(cmd.switch)
        end
      end
      
      def required_args
        [ self.name, self.action ]
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
        actions = [ 'Roster', 'Destroy', 'Dead', 'Gone', "Npc", "Warn" ]
        return t('idle.invalid_action', :actions => actions.join(" ")) if !actions.include?(self.action)
        return nil
      end
            
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          client.program[:idle_queue][model.id] = self.action
          client.emit_success t('idle.idle_action_set', :name => self.name, :action => self.action)
          if (self.action == 'Destroy' && model.is_approved?)
            client.emit_failure t('idle.destroy_approved_warning')
          end
        end
      end
    end
  end
end
