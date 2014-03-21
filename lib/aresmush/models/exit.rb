module AresMUSH
  class Exit
    include MongoMapper::Document
    
    key :name
    key :name_upcase, String
        
    key :source_id, ObjectId
    belongs_to :source, :class => Room
    
    key :dest_id, ObjectId
    belongs_to :dest, :class => Room
    
    before_validation :save_upcase_name
    
    def save_upcase_name      
      @name_upcase = @name.nil? ? "" : @name.upcase
    end
  end
end
