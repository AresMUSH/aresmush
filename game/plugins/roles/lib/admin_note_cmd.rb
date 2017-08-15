module AresMUSH
  module Roles
    class AdminNoteCmd
      include CommandHandler
      
      attr_accessor :note

      def parse_args
        self.note = cmd.args
      end
      
      def required_args
        [ self.note ]
      end
      
      def handle
        enactor.update(role_admin_note: self.note)
        client.emit_success t('roles.admin_note_set')
      end
    end
  end
end