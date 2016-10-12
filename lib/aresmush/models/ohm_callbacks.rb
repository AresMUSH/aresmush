module Ohm
  module Callbacks
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end

    module ClassMethods
      @@default_values_callbacks = {}
      @@before_save_callbacks = {}
      @@before_delete_callbacks = {}
      
      def register_data_members
        @@default_values_callbacks[self] = []
        @@before_save_callbacks[self] = []
        @@before_delete_callbacks[self] = []
      end

      def default_values(sym)
        @@default_values_callbacks[self] << sym
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
    
      def default_values_callbacks
        @@default_values_callbacks[self]
      end
    
      def before_delete_callbacks
        @@before_delete_callbacks[self]
      end
        
      def create(args = {})
        self.default_values_callbacks.each do |callback|
          puts "Before create #{callback}"
          default_args = self.send(callback)
          default_args.each do |k,v|
            if (!args.has_key?(k))
              args[k] = v
            end
          end
        end
        super
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