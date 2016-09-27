module AresMUSH
  module SupportingObjectModel
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
 
    module ClassMethods
      def register_data_members
        send :include, Mongoid::Document
        send :include, Mongoid::Timestamps
        send :include, Lockable
        field :model_version, :type => Integer, default: 1
      end
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end
  end
end