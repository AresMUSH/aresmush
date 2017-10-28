module AresMUSH
  module Manage
    class BackupCmd
      include CommandHandler
      
      def handle
        num_backups = Global.read_config("manage", "backups_to_keep")
        
        backup = AwsBackup.new
        backup.backup(client)
      end
    end
  end
end
