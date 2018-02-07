module AresMUSH
  module Manage
    class LocalBackup
      
      # Client may be nil for nightly automated backup
      def backup(client)
        Global.dispatcher.spawn("Performing backup.", client) do
          db_path = Global.read_config("database", "path")
          num_backups = Global.read_config("backup", "backups_to_keep")
      
          if (!num_backups)
            Global.logger.warn "Backups not enabled."
            client.emit_failure t('manage.backups_not_enabled') if client
            next
          end
      
          Global.logger.info "Starting backup."
          client.emit_success t('manage.starting_backup') if client
      
          files = Dir[File.join(AresMUSH.root_path, "backups", "*")].sort
      
          if (files.count >= num_backups)
            oldest_backup = files.shift
            Global.logger.debug "Deleting #{oldest_backup}"
            FileUtils.rm oldest_backup, :force=>true
          end
      
          backup_path = Manage.create_backup_file
      
          Global.logger.info "Backup complete."
          client.emit_success t('manage.backup_complete') if client
        end
      end
    end
  end
end