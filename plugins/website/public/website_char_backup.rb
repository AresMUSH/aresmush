module AresMUSH
  class WikiCharBackup < Ohm::Model
    include ObjectModel

    reference :char, "AresMUSH::Character"
    attribute :file
    
    before_delete :delete_backup
    
    def self.retention_hours
      48
    end
    
    def file_path
      File.join(AresMUSH.game_path, self.file)
    end
    
    def download_path
      "#{Game.web_portal_url}/game/#{self.file}"
    end
    
    def hours_old
      (Time.now - self.created_at) / 3600
    end
    
    def delete_backup
      begin
        FileUtils.rm self.file_path
      rescue Exception => e
        Global.logger.warn "Couldn't clear wiki backup file: #{self.download_path}"        
      end
    end
  end
end