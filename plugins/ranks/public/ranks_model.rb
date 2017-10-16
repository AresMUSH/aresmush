module AresMUSH
  class Character
    attribute :ranks_rank

    def rank
      self.ranks_rank
    end
    
    def military_name
      Ranks.military_name(self)
    end
  end
end