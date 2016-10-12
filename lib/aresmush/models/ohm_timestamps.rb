# With credit to: https://github.com/sinefunc/ohm-contrib

module Ohm
  module Timestamps
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end

    module ClassMethods
        
      def register_data_members
        send :include, Ohm::DataTypes
        attribute :created_at, Ohm::DataTypes::DataType::Time
        attribute :updated_at, Ohm::DataTypes::DataType::Time
        default_values :default_created_date
        before_save :set_updated_date
      end
      def default_created_date
        { created_at: Time.now.to_s }
      end
    end
  

    def set_updated_date
      self.updated_at = Time.now.to_s
    end
  
  end
end
