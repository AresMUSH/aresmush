module AresMUSH
  
  class Character
    
    def idled_out?
      !!self.idle_state
    end
    
    def on_roster?
      self.idle_state == "Roster"
    end
    
    def idled_out_reason
      self.idle_state
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