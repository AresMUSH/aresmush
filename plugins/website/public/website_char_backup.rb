module AresMUSH
  class WikiCharBackup < Ohm::Model
    include ObjectModel

    reference :char, "AresMUSH::Character"
    attribute :file
    
    before_delete :delete_backup
    
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
      FileUtils.rm self.file_path
    end
  end
end