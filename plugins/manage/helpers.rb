module AresMUSH
  module Manage
    def self.can_manage_game?(actor)
      return false if !actor
      actor.has_permission?("manage_game")
    end
    
    def self.can_announce?(actor)
      return false if !actor
      actor.has_permission?("announce")
    end
    
    def self.can_manage_rooms?(actor)
      return false if !actor
      actor.has_permission?("build") || self.can_manage_game?(actor)
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
      case (type)
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
      backup_path = File.join(AresMUSH.root_path, "backups", backup_filename)
      
      Zip::File.open(backup_path, 'w') do |zipfile|
        Dir["#{AresMUSH.game_path}/**/**"].each do |file|
          zipfile.add(file.sub(AresMUSH.game_path+'/',''),file)
        end
        zipfile.add('dump.rdb', db_path)
      end
      
      backup_path
    end
  end
end
