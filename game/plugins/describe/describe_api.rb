module AresMUSH
  module Describe
    module Api
      def self.desc_template(model, enactor)     
        Describe.get_desc_template(model, enactor)
      end
      
      def self.create_or_update_desc(model, description, type = :current)
        Describe.create_or_update_desc(model, description, type)
      end
      
      def self.app_review(char)
        Describe.app_review(char)
      end
    end
  end
end
