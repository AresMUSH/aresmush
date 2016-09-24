module AresMUSH
  module Describe
    module Api
      def self.desc_template(model, client)     
        Describe.get_desc_template(model, client)
      end
      
      def self.app_review(char)
        Describe.app_review(char)
      end
    end
  end
end
