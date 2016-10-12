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
        attribute :created_at, :type => Ohm::DataTypes::DataType::Time
        attribute :updated_at, :type => Ohm::DataTypes::DataType::Time
        before_save :update_dates
      end
    end
  

    def update_dates
      self.created_at ||= Time.now.to_s
      self.updated_at = Time.now.to_s
    end
  
  end
end
