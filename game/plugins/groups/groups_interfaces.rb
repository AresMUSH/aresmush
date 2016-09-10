module AresMUSH
  module Groups
    module Interface
      def self.app_review(char)
        Groups.app_review(char)
      end
      
      def self.group(char, name)
        char.groups[name]
      end
    end
  end
end