module AresMUSH
  module Groups
    module Api
      def self.app_review(char)
        Groups.app_review(char)
      end
      
      def self.group(char, name)
        char.group(name)
      end
    end
  end
end