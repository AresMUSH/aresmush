module AresMUSH
  module FindByName

    def self.included(base)
      base.send :extend, ClassMethods   
      #base.send :register_data_members
    end
 
    module ClassMethods
      #def register_data_members
      #end
    
      def find_any_by_name(name_or_id)
        return [] if !name_or_id
        result = self[name_or_id]
        if result
          return [result]
        end
        find(name_upcase: name_or_id.upcase).to_a.select { |x| x }
      end

      def find_one_by_name(name)
        find_any_by_name(name).first
      end
    
      def found?(name)
        !!find_one_by_name(name)
      end
      
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end
  end
end