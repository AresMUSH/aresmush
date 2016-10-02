module AresMUSH
  class SimpleData < Ohm::Model
    attribute :data
  end
  
  module ObjectModel
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
 
    module ClassMethods
      def register_data_members
        send :include, Mongoid::Document
        send :include, Mongoid::Timestamps
        send :include, Lockable

        field :name, :type => String
        field :name_upcase, :type => String
        field :alias, :type => String
        field :alias_upcase, :type => String
        field :model_version, :type => Integer, default: 1
        before_validation :save_upcase_name
      end

      def find_any(name_or_id)
        return nil if name_or_id.blank?
        where({ :$or => [{ :name_upcase => name_or_id.upcase }, { :alias_upcase => name_or_id.upcase }, { :id => name_or_id }] }).all
      end

      def find_one(name)
        return nil if name.blank?
        where({ :$or => [{ :name_upcase => name.upcase }, { :alias_upcase => name.upcase }] }).first
      end

      def find_any(name)
        return nil if name.blank?
        where({ :$or => [{ :name_upcase => name.upcase }, { :alias_upcase => name.upcase }] }).all
      end
    
      def found?(name)
        existing = find_one(name)
        return existing
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
      self.name_upcase = !self.name ? "" : self.name.upcase
      self.alias_upcase = !self.alias ? "" : self.alias.upcase
    end
    
  end
end