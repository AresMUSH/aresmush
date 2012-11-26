module AresMUSH
  module Exit
    extend AresModel
    
    def self.coll
      :exits
    end
    
    # TODO Spec
    def self.exits_from(room)
      find("source" => room["_id"])
    end        
  end
end
