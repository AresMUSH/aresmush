module AresMUSH

  module Roster
    class RosterRemoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end

      def check_can_remove
        return nil if Roster.can_manage_roster?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
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
