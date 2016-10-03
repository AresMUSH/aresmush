module Ohm
  module Callbacks
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end

    module ClassMethods
        
      def register_data_members
        @@before_create_callbacks = []
        @@before_save_callbacks = []
        @@before_delete_callbacks = []
      end

      def before_create(sym)
        @@before_create_callbacks << sym
      end    
    
      def before_save(sym)
        @@before_save_callbacks << sym
      end
    
      def before_delete(sym)
        @@before_delete_callbacks << sym
      end
    
      def before_save_callbacks
        @@before_save_callbacks
      end
    
      def before_create_callbacks
        @@before_create_callbacks
      end
    
      def before_delete_callbacks
        @@before_delete_callbacks
      end
    end
  
    def save
      if (new?)
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