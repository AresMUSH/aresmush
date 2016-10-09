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
  
  def pretty_print
    json = JSON.pretty_generate(self.attributes)
    self.methods.each do |m|
      if (m.to_s.end_with?('_id'))
        method = m.to_s.gsub('_id', '')
        if (self.respond_to?(method))
          nested = self.send(method)
          next if !nested
          json << "\n#{method}: #{JSON.pretty_generate(nested.attributes)}"
        end
      end
    end
    json
  end
end