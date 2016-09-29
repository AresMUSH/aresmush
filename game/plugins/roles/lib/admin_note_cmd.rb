module AresMUSH
  module Roles
    class AdminNoteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :note
     
      def initialize(client, cmd, enactor)
        self.required_args = ['note']
        self.help_topic = 'admin'
        super
      end
      
      def crack!
        self.note = cmd.args
      end
      
      def handle
        enactor.admin_note = self.note
        enactor.save!
        client.emit_success t('roles.admin_note_set')
      end
    end
  end
end