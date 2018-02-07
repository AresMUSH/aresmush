module AresMUSH
  module Manage
    class BackupCmd
      include CommandHandler
      
      def handle
        Manage.perform_backup(client)
      end
    end
  end
end
