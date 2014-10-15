module AresMUSH
  class Game
    
    include Mongoid::Document
    
    field :model_version, :type => Integer, default: 1
    
    belongs_to :system_character, :class_name => "AresMUSH::Character", :inverse_of => nil
    belongs_to :master_admin, :class_name => "AresMUSH::Character", :inverse_of => nil
    
    # There's only one game document and this is it!
    def self.master
      Game.all.first
    end
    
    def is_special_char?(char)
      return true if char == system_character
      return true if char == master_admin
      return false
    end
  end
end
