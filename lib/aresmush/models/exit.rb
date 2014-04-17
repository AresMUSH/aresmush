module AresMUSH
  class Exit
    include ObjectModel

    field :source_id, :type => Moped::BSON::ObjectId
    belongs_to :source, :class_name => 'AresMUSH::Room', :inverse_of => 'exits'
    
    field :dest_id, :type => Moped::BSON::ObjectId
    belongs_to :dest, :class_name => 'AresMUSH::Room',  :inverse_of => nil

    register_default_indexes
  end
end
