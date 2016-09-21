module AresMUSH
  class Character
    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| self.roles.include?(n) }
      end
    end  
  end
  
  module Roles
    module Api
      def self.valid_role?(name)
        Roles.valid_role?(name)
      end
    
      def self.chars_with_role(name)
        Roles.chars_with_role(name)
      end
      
      def self.is_master_admin?(char)
        char.is_master_admin?
      end
      
      def self.is_admin?(char)
        char.is_admin?
      end
    end
  end
end