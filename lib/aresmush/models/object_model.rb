module ObjectModel
  def self.included(base)
    base.send :extend, ClassMethods   
    base.send :register_data_members
  end

  module ClassMethods
        
    def register_data_members
      send :include, Ohm::DataTypes
      send :include, Ohm::Timestamps
      send :include, Ohm::Callbcaks
    end
  end
end