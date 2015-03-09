module AresMUSH

  module Roster
    class RosterRemoveCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("roster") && cmd.switch_is?("remove")
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
