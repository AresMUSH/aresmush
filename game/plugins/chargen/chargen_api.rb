module AresMUSH
  class Character
    field :is_approved, :type => Boolean, :default => false
    
    def is_approved?
      self.is_approved
    end  
  end
  
  module Chargen
    module Api
    
      def self.background(char)
        char.background
      end
            
      def self.format_review_status(msg, error)
        Chargen.format_review_status(msg, error)
      end
      
      def self.check_chargen_locked(char)
        Chargen.check_chargen_locked(char)
      end
      
      def self.is_in_stage?(char, stage_name)
        Chargen.is_in_stage?(char, stage_name)
      end
      
      def self.approval_status(char)
        Chargen.approval_status(char)
      end
    end    
  end
end