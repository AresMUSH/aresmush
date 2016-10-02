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
        enactor.admin_note = self.note
        enactor.save!
        client.emit_success t('roles.admin_note_set')
      end
    end
  end
end