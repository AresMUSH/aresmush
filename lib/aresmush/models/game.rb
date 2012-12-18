module AresMUSH
  module Game
    def self.coll
      :game
    end
        
    def self.create
      model = {}
      db[coll].insert(model)
      model
    end    
    
    def self.get
      db[coll].find().to_a[0]
    end
    
    def self.update(model)
      db[coll].update( { "_id" => model["_id"] }, model)
    end
    
    def self.drop_all
      db[coll].drop
    end
  end
end
