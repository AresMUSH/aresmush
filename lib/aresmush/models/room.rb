module AresMUSH
  class Room
    
    def self.find(*args)
      db[:rooms].find(*args).to_a
    end
    
    def self.find_by_id(id)
      if (id.class == BSON::ObjectId)
        find("_id" => id)
      elsif (BSON::ObjectId.legal?(id))
        find("_id" => BSON::ObjectId(id))
      else
        []
      end
    end
    
    def self.find_match(name_or_id)
      room = find_by_id(name_or_id)
      room = find("name_upcase" => name_or_id.upcase) if room.empty?
      room
    end
    
    def self.update(room)
      db[:rooms].update( { "_id" => room["_id"] }, room)
    end
    
    def self.create(name)
      room = 
       {
         "name"       => name,
         "name_upcase" => name.upcase
       }
       room["id"] = db[:rooms].insert(room)
       room 
    end
  end
end
