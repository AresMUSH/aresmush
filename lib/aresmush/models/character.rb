module AresMUSH
    module Character
    
    extend AresModel
    
    def self.coll
      :chars
    end    

    def self.create_char(name, raw_password)
      Character.create("name" => name, "password" => Character.hash_password(raw_password))      
    end
    
    def self.exists?(name)
      existing_char = Character.find_by_name(name)
      return !existing_char.empty?
    end
    
    def self.custom_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model["type"] = "Character"
      model
    end
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
    def self.compare_password(char, password)
      hash = BCrypt::Password.new(char["password"])
      hash == password
    end
  end
end
    