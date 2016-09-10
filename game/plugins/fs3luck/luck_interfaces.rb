module AresMUSH
  module FS3Luck
    module Interface
      def self.luck(char)
        char.luck
      end
      
      # Does not save!  Must do that yourself!
      def self.award_luck(char, amount)
        FS3Luck.modify_luck(char, amount)
      end
      
      # Does not save!  Must do that yourself!
      def self.spend_luck(char, amount)
        FS3Luck.modify_luck(char, -amount)
      end
    end
  end
end