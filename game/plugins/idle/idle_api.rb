module AresMUSH
  
  class Character
    
    def idled_out?
      self.idle_status
    end
    
    def idled_out_reason
      self.idle_status.status
    end
  end
  
  module Idle
    module Api
      def self.active_chars
        Idle.active_chars
      end
    end
  end
end