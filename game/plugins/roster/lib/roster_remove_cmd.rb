module AresMUSH

  module Roster
    class RosterRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'roster'
        }
      end
      
      def check_can_remove
        return nil if Roster.can_manage_roster?(enactor)
        return t('dispatcher.not_allowed')
      end

      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.roster_registry)
            client.emit_failure t('roster.not_on_roster', :name => model.name)
            return
          end

          model.roster_registry.destroy
          client.emit_success t('roster.removed_from_roster', :name => model.name)
        end
      end
    end
  end
end
