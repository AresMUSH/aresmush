module ObjectModel
  def self.included(base)
    base.send :extend, ClassMethods   
    base.send :register_data_members
  end

  module ClassMethods
        
    def register_data_members
      send :include, Ohm::DataTypes
      send :include, Ohm::Callbacks
      send :include, Ohm::Timestamps
    end
    
    def find_one(args)
      find(args).first
    end
  end
end