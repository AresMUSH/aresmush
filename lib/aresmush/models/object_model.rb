module AresMUSH
  module ObjectModel

    mattr_reader :models
    @@models = Set.new

    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
      @@models << base
    end
 
    module ClassMethods
      def register_data_members
        send :include, Mongoid::Document
        send :include, Mongoid::Timestamps
        field :name, :type => String
        field :name_upcase, :type => String
        field :model_version, :type => Integer, default: 1
        before_validation :save_upcase_name
        after_save :reload_clients
        after_destroy :reload_clients
      end

      def find_all_by_name_or_id(name_or_id)
        where({ :$or => [{ :name_upcase => name_or_id.upcase }, { :id => name_or_id }] }).all
      end

      def find_by_name(name)
        find_by(name_upcase: name.upcase)
      end

      def find_all_by_name(name)
        where(:name_upcase => name.upcase).all
      end
      
      # Derived classes may implement name checking
      def check_name(name)
        nil
      end

      def register_default_indexes(with_unique_name: false)
        index({ name: 1 }, { unique: with_unique_name, name: 'name_idx' })
        index({ name_upcase: 1 }, { unique: with_unique_name, name: 'name_upcase_idx' })
      end
      
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end

    private
    def save_upcase_name
      self.name_upcase = self.name.nil? ? "" : self.name.upcase
    end
    
    def reload_clients
      Global.client_monitor.reload_clients
    end
  end
end