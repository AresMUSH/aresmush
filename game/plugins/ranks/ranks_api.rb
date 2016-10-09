module AresMUSH
  class Character
    def rank
      self.ranks_rank
    end
  end
  
  
  module Ranks
    
    module Api
      def self.app_review(char)
        Ranks.app_review(char)
      end
    end
  end
end