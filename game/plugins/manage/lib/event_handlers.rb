module AresMUSH
  module Manage    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("manage", "backup_cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        backup = AwsBackup.new
        error = backup.backup
      end
    end    
  end
end