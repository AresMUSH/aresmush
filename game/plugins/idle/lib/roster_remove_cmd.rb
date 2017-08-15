module AresMUSH

  module Idle
    class RosterRemoveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_roster_enabled
        return t('idle.roster_disabled') if !Idle.roster_enabled?
        return nil
      end
      
      def check_can_remove
        return nil if Idle.can_manage_roster?(enactor)
        return t('dispatcher.not_allowed')
      end

      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.on_roster?)
            client.emit_failure t('idle.not_on_roster', :name => model.name)
            return
          end

          model.update(idle_state: nil)
          client.emit_success t('idle.removed_from_roster', :name => model.name)
        end
      end
    end
  end
end
