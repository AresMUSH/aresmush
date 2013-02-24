require 'date'

module AresMUSH
  module AresModel
    
    # Define this with the mongo collection your model uses.  
    # For example: :players
    def coll
      raise "Collection not defined!"
    end

    # Define this with any special fields your model needs to set at create time.
    # For example, the Player model sets name_upcase
    def custom_model_fields(model) 
      model     
    end
    
    def find(*args)
      db[coll].find(*args).to_a
    end

    def update(model)
      id = id_to_update(model)
      db[coll].update( { :_id => id }, model)
    end

    def id_to_update(model)
      return model[:_id] if !model[:_id].nil?
      return model["_id"] if !model["_id"].nil?
      return model[:id] if !model[:id].nil?
      return model["id"] if !model["id"].nil?
      return nil
    end
    
    def find_by_id(id)
      if (id.class == BSON::ObjectId)
        find("_id" => id)
      elsif (BSON::ObjectId.legal?(id))
        find("_id" => BSON::ObjectId(id))
      else
        []
      end
    end

    def find_by_name(name)
      find("name_upcase" => name.upcase)
    end

    def find_by_name_or_id(name_or_id)
      model = find_by_id(name_or_id)
      model = find_by_name(name_or_id) if model.empty?
      model
    end

    def create(*args)
      model = args[0]
      model["create date"] = Time.now
      model = custom_model_fields(model)
      db[coll].insert(model)
      model
    end
    
    def drop_all
      db[coll].drop
    end
  end

end