module AresMUSH
  class Character
    reference :wiki_char_backup, "AresMUSH::WikiCharBackup"
    attribute :website_editor, :default => "WYSIWYG"
    
    before_delete :delete_backup
    
    def delete_backup
      if (self.wiki_char_backup)
        self.wiki_char_backup.delete
      end
    end
  end
end