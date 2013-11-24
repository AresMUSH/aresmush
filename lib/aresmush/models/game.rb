module AresMUSH
  module Game
    def self.coll
      :game
    end
        
    def self.create
      model = {}
      Global.db[coll].insert(model)
      model
    end    
    
    def self.get
      Global.db[coll].find().to_a[0]
    end
    
    def self.update(model)
      Global.db[coll].update( { "_id" => model["_id"] }, model)
    end
    
    def self.drop_all
      Global.db[coll].drop
    end
  end
end
