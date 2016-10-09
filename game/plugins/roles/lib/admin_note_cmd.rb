module AresMUSH
  module Roles
    class AdminNoteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :note

      def crack!
        self.note = cmd.args
      end
      
      def required_args
        {
          args: [ self.note ],
          help: 'admin'
        }
      end
      
      def handle
        enactor.update(role_admin_note: self.note)
        client.emit_success t('roles.admin_note_set')
      end
    end
  end
end