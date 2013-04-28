module AresMUSH
  module AresModel

    # Define this with the mongo collection your model uses.  
    # For example: :chars
    def coll
      raise "Collection not defined!"
    end

    # Define this with any special fields your model needs to set at create time.
    # For example, the Character model sets name_upcase
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

    def find_by_location(loc_id)
      find("location" => loc_id)
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

    def find_one(name_or_id)
      results = find_by_name_or_id(name_or_id)
      return nil if results.empty?
      return nil if results.count > 1
      results[0]
    end
    
    def self.model_class(model)
      begin
        AresMUSH.const_get(model["type"])
      rescue TypeError, NameError
        nil
      end
    end
  end
end