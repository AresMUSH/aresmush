module AresMUSH
  module Describe
    module Interface
      def self.desc_template(model, client)     
        Describe.get_desc_template(model, client)
      end
      
      def self.app_review(char)
        Describe.app_review(char)
      end
      
      def self.char_backup(char, client)
        Describe.char_backup(char, client)
      end
    end
  end
end
