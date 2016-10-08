module Ohm
  module Callbacks
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end

    module ClassMethods
      @@before_create_callbacks = {}
      @@before_save_callbacks = {}
      @@before_delete_callbacks = {}
      
      def register_data_members
        @@before_create_callbacks[self] = []
        @@before_save_callbacks[self] = []
        @@before_delete_callbacks[self] = []
      end

      def before_create(sym)
        @@before_create_callbacks[self] << sym
      end    

      def before_save(sym)
        @@before_save_callbacks[self] << sym
      end
    
      def before_delete(sym)
        @@before_delete_callbacks[self] << sym
      end
       
      def before_save_callbacks
        @@before_save_callbacks[self]
      end
    
      def before_create_callbacks
        @@before_create_callbacks[self]
      end
    
      def before_delete_callbacks
        @@before_delete_callbacks[self]
      end
    end
  
    def save
      is_new = new?
      if (is_new)
        self.class.before_create_callbacks.each do |callback|
          self.send(callback)
        end
      end
      self.class.before_save_callbacks.each do |callback|
        self.send(callback)
      end
      super
    end
  
    def delete
      self.class.before_delete_callbacks.each do |callback|
        self.send(callback)
      end
      super
    end
  end
end