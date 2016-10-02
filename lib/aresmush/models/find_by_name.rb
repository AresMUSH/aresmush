module AresMUSH
  module FindByName

    def self.included(base)
      base.send :extend, ClassMethods   
      #base.send :register_data_members
    end
 
    module ClassMethods
      #def register_data_members
      #end
    
      def find_any(name_or_id)
        return [] if !name_or_id
        result = self[name_or_id]
        if result
          return [result]
        end
        find(name_upcase: name_or_id).to_a
      end

      def find_one(name)
        find_any(name).first
      end
    
      def found?(name)
        find_any(name).first
      end
      
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end
  end
end