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
        results = find(id: name_or_id)
        if (results.empty?)
          results = find(name_upcase: name_or_id)
        end
        results
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