module AresMUSH
  class Character
    attribute :pools_pool, :type => DataType::Integer, :default => 0
    
    def pool
      self.pools_pool
    end
    
    def add_pool(amount)
      Pools.modify_pool(self, amount)
    end
    
    def spend_pool(amount)
      Pools.modify_pool(self, -amount)
    end
    
    def set_pool(amount)
      Pools.set_pool(self, amount)
    end
    
  end
end