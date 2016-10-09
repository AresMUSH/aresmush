module AresMUSH
  module Groups
    module Api
      def self.app_review(char)
        Groups.app_review(char)
      end
      
      def self.group(char, name)
        group = char.group(name)
        group ? group.value : nil
      end
    end
  end
end