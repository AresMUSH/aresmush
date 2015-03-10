module AresMUSH

  module Roster
    class RosterAddCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :contact
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("roster") && (cmd.switch_is?("add") || cmd.switch_is?("update"))
      end

      def check_can_add
        return nil if Roster.can_manage_roster?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.contact = titleize_input(cmd.args.arg2)
      end
      
      def handle
        Roster.create_or_update_roster(client, self.name, self.contact)
      end
    end
  end
end
