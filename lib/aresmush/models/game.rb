module AresMUSH
  class Game
    
    include Mongoid::Document
    
    field :model_version, :type => Integer, default: 1
    field :system_character_id, :type => Moped::BSON::ObjectId
    field :master_admin_id, :type => Moped::BSON::ObjectId
    
    # There's only one game document and this is it!
    def self.master
      Game.all.first
    end
    
    def system_character
      Character.find(self.system_character_id)
    end
    
    def master_admin
      Character.find(self.master_admin_id)
    end
    
    def is_special_char?(char)
      return true if char == system_character
      return true if char == master_admin
      return false
    end
  end
end
