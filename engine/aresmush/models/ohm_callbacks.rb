module Ohm
  module Callbacks
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end

    module ClassMethods
      @@before_save_callbacks = {}
      @@before_delete_callbacks = {}
      
      def register_data_members
        @@before_save_callbacks[self] = []
        @@before_delete_callbacks[self] = []
      end

      def before_save(sym)
        if (!@@before_save_callbacks[self].include?(sym))
          @@before_save_callbacks[self] << sym
        end
      end
    
      def before_delete(sym)
        if (!@@before_delete_callbacks[self].include?(sym))
          @@before_delete_callbacks[self] << sym
        end
      end
       
      def before_save_callbacks
        @@before_save_callbacks[self]
      end
    
      def before_delete_callbacks
        @@before_delete_callbacks[self]
      end      
    end
          
    def save
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