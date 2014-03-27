module AresMUSH
  class Exit
    include BaseModel

    key :source_id, ObjectId
    belongs_to :source, :class => Room
    
    key :dest_id, ObjectId
    belongs_to :dest, :class => Room

    def self.find_all_by_name_or_id(name_or_id)
      where( { :$or => [ { :name_upcase => name_or_id.upcase }, { :id => name_or_id } ] } ).all
    end
    
  end
end
