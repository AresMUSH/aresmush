module AresMUSH
  class Character
    def group(name)
      GroupAssignment.find(character_id: self.id).combine(group: name).first
    end
    
    def group_value(name)
      group = group(name)
      group ? group.value : nil
    end
  end
  
  module Groups
    module Api
      def self.app_review(char)
        Groups.app_review(char)
      end
    end
  end
end