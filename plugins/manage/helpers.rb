module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      actor && actor.has_permission?("manage_game")
    end
    
    def self.can_announce?(actor)
      actor && actor.has_permission?("announce")
    end
    
    def self.can_manage_rooms?(actor)
      return true if Manage.can_manage_game?(actor)
      actor && actor.has_permission?("build")
    end
    
    def self.can_manage_object?(actor, model)
      return false if !actor
      if (model.class == Room || model.class == Exit)
        self.can_manage_rooms?(actor)
      else
        self.can_manage_game?(actor)
      end
    end
    
    def self.perform_backup(client = nil)
      type = Global.read_config("backup", "backup_type")
      case (type.downcase)
      when "aws"
        backup = AwsBackup.new
        backup.backup(client)
      when "local"
        backup = LocalBackup.new
        backup.backup(client)
      else
        Global.logger.warn "Invalid backup type: #{type}"
        client.emit_failure t('manage.backups_not_enabled') if client
      end
    end
      
    def self.create_backup_file
      db_path = Global.read_config("database", "path")
      timestamp = Time.now.strftime("%Y%m%d%k%M%S")        
      backup_filename = "#{timestamp}-backup.zip"
      backup_dir = File.join(AresMUSH.root_path, "backups")
      backup_path = File.join(backup_dir, backup_filename)
      
      if (!Dir.exist?(backup_dir))
        Dir.mkdir(backup_dir)
      end
      
      Zip::File.open(backup_path, 'w') do |zipfile|
        Dir["#{AresMUSH.game_path}/**/**"].each do |file|
          zipfile.add(file.sub(AresMUSH.game_path+'/',''),file)
        end
        zipfile.add('dump.rdb', db_path)
      end
      
      backup_path
    end
    
    def self.restore_config(file)
      begin
        default_config = DatabaseMigrator.read_distr_config_file(file)
        DatabaseMigrator.write_config_file(file, default_config)    
        error = Manage.reload_config
        return error
      rescue Exception => ex
        return ex.message
      end
    end
    
    def self.start_upgrade
      Global.logger.debug "Starting upgrade."
      upgrade_script_path = File.join AresMUSH.root_path, "bin", "upgrade"
      `#{upgrade_script_path} 2>&1`
    end
    
    def self.finish_upgrade(enactor, from_web)
      Global.logger.debug "Finishing upgrade."
      
      if (AresMUSH.version != Website.webportal_version)
        return t('manage.mismatched_versions')
      end
      
      Manage.load_all
      
      error = Manage.run_migrations
      if (error)
        return error
      end
      
      Global.config_reader.load_game_config
      Website.redeploy_portal(enactor, from_web)
      return t('webportal.redeploying_website')
    end
    
    def self.load_all
      begin
        # Make sure everything is valid before we start.
        Global.config_reader.validate_game_config          
      rescue Exception => ex
        return t('manage.game_config_invalid', :error => ex)
      end
      
      Global.plugin_manager.all_plugin_folders.each do |load_target|
        begin
          Global.plugin_manager.unload_plugin(load_target)
        rescue SystemNotFoundException
          # Swallow this error.  Just means you're loading a plugin for the very first time.
        end
      end
      Global.config_reader.load_game_config
      # zzzzzzcustom is just a hack to get it to load after all the others.
      Global.plugin_manager.all_plugin_folders.sort_by { |p| p == 'custom' ? 'zzzzzzzcustom' : p }.each do |load_target|
        begin
          Global.plugin_manager.load_plugin(load_target)                      
        rescue SystemNotFoundException => e
          return t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          Global.logger.debug "Error loading plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
          return t('manage.error_loading_plugin', :name => load_target, :error => e)
        end
      end
      Help.reload_help
      Global.locale.reload
      Website.rebuild_css
      Global.dispatcher.queue_event ConfigUpdatedEvent.new
      return nil
    end
      
    def self.run_migrations
      Manage.announce t('manage.database_upgrade_in_progress')
      error = nil
      begin
        migrator = AresMUSH::DatabaseMigrator.new
        migrator.migrate(:online)
      rescue Exception => e
        Global.logger.debug "Error loading plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
        error = t('manage.error_running_migrations', :error => e)
      end
      
      Manage.announce t('manage.database_upgrade_complete')
      return error
    end
  end
end
