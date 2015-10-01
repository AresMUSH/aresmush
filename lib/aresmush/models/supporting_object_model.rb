module AresMUSH
  module SupportingObjectModel

    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
      #base.reset_storage_options!
    end
 
    module ClassMethods
      def register_data_members
        send :include, Mongoid::Document
        send :include, Mongoid::Timestamps
        field :model_version, :type => Integer, default: 1
        after_save :reload_clients
        after_destroy :reload_clients
      end
    end
    
    def to_json
      JSON.pretty_generate(as_json)
    end

    private
    def reload_clients
      Global.client_monitor.reload_clients
    end
  end
end