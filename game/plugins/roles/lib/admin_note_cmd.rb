module AresMUSH
  module Roles
    class AdminNoteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :note
     
      def initialize
        self.required_args = ['note']
        self.help_topic = 'admin'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("adminnote")
      end

      def crack!
        self.note = cmd.args
      end
      
      def handle
        client.char.admin_note = self.note
        client.char.save!
        client.emit_success t('roles.admin_note_set')
      end
    end
  end
end