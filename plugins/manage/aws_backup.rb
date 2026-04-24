require 'rexml'
require 'aws-sdk-s3'

module AresMUSH
  module Manage
    class AwsBackup
      
      # Client may be nil for nightly automated backup
      def backup(client)
        Global.dispatcher.spawn("Performing backup.", client) do
          region = Global.read_config("secrets", "aws", "region")
          bucket_name = Global.read_config("secrets", "aws", "bucket")
          key_id = Global.read_config("secrets", "aws", "key_id")
          key = Global.read_config("secrets", "aws", "secret_key")
          num_backups = Global.read_config("backup", "backups_to_keep")
      
          if (!num_backups || !bucket_name || bucket_name.blank?)
            Global.logger.warn "Backups not enabled."
            client.emit_failure t('manage.backups_not_enabled') if client
            next
          end
      
          Global.logger.info "Starting backup to AWS."
          client.emit_success t('manage.starting_backup') if client
      
          credentials = Aws::Credentials.new(key_id, key)
          s3 = Aws::S3::Resource.new(region: region, credentials: credentials)
          if (!s3)
            Global.logger.error "Can't authenticate to AWS."
            client.emit_failure t('manage.aws_problem') if client
            next
          end
      
          bucket = s3.bucket(bucket_name)
          if (!bucket)
            Global.logger.error "Can't find bucket #{bucket_name}."
            client.emit_failure t('manage.aws_problem') if client
            next
          end
      
          timestamp = Time.now.strftime("%Y%m%d%k%M%S")        
          files = bucket.objects.map { |k| k.key }.sort
      
          if (files.count >= num_backups)
            oldest_backup = files.shift
            obj = bucket.object(oldest_backup)
            Global.logger.debug "Deleting #{oldest_backup}"
            obj.delete
          end
      
      
          backup_path = Manage.create_backup_file
          backup_filename = File.basename(backup_path)
          
          obj = bucket.object(backup_filename)
          obj.upload_file(backup_path)
          FileUtils.rm backup_path, :force=>true
      
          Global.logger.info "Backup complete."
          client.emit_success t('manage.backup_complete') if client
        end
      end
    end
  end
end