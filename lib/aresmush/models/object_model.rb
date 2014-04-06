module AresMUSH
  module ObjectModel
    def self.included(base)
      base.send :extend, ClassMethods   
      base.register_data_members
    end
 
    module ClassMethods
      def register_data_members
        send :include, MongoMapper::Document
        plugin MongoMapper::Plugins::IdentityMap
        key :name, String
        key :name_upcase, String
        timestamps!
        before_validation :save_upcase_name
      end

      def find_all_by_name_or_id(name_or_id)
        where({ :$or => [{ :name_upcase => name_or_id.upcase }, { :id => name_or_id }] }).all
      end

      def find_by_name(name)
        find_by_name_upcase(name.upcase)
      end

      def find_all_by_name(name)
        find_all_by_name_upcase(name.upcase)
      end
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end

    private
    def save_upcase_name
      @name_upcase = @name.nil? ? "" : @name.upcase
    end
  end
end