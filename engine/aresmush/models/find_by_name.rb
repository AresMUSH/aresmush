module AresMUSH
  module FindByName

    def self.included(base)
      base.send :extend, ClassMethods   
      #base.send :register_data_members
    end
 
    module ClassMethods
      #def register_data_members
      #end
    
      def find_any_by_id(id)
        prefix = id.after("#").before("-")
        if (prefix == self.dbref_prefix)
          return [self[id.after("-")]]
        else
          return []
        end
      end
      
      def find_any_by_name(name_or_id)
        return [] if !name_or_id
        
        if (name_or_id.start_with?("#"))
          return find_any_by_id(name_or_id)
        end
        find(name_upcase: name_or_id.upcase).to_a.select { |x| x }
      end

      def named(name)
        find_one_by_name(name)
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