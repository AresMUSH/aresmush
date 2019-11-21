module AresMUSH
  class Exit    
    attribute :lock_keys, :type => DataType::Array, :default => []
    
    def allow_passage?(char)
      return false if (self.lock_keys == Rooms.interior_lock)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
    
    def owned_by?(char)
      self.source && self.source.room_owners.include?(char)
    end
    
    def destination_name
      !self.dest ? t('describe.nowhere') : self.dest.name
    end
    
  end
end