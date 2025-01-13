module AresMUSH
  class Character
    before_delete :delete_blocks
    
    def can_manage_game?
      Manage.can_manage_game?(self)
    end
        
    def delete_blocks
      self.blocks.each { |b| b.destroy }
      BlockRecord.all.select { |b| b.blocked == self }.each { |b| b.destroy }
    end
    
  end
end