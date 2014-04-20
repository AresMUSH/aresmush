module AresMUSH
  class Game
    
    include Mongoid::Document
    
    field :model_version, :type => Integer, default: 1
    
    # There's only one game document and this is it!
    def self.master
      Game.all.first
    end
  end
end
