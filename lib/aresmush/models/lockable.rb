module AresMUSH
  class StaleObjectError < StandardError
  end
  
  module Lockable
    
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
 
    module ClassMethods
      def register_data_members
        field :lock_field, :type => Integer, :default => 0        
        before_save :check_lock_field
      end
    end
    
    def check_lock_field
      old_lock = self.lock_field
      existing = _reload # get the current root or embedded document
      if (existing)
        Global.logger.debug "#{existing['lock_field']} && #{self.lock_field} && #{old_lock}"
        if (existing.class == Array)
          existing = existing.first
        end
      end
      if existing.present? && existing['lock_field'] &&
        existing['lock_field'].to_i > old_lock.to_i
        raise new StaleObjectError
      end
      self.lock_field = (self.lock_field ? self.lock_field + 1 : 1)
    end
  end
end

