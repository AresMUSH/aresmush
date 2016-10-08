module AresMUSH
  module Friends
    module Api
      def self.is_friend?(char, potential_friend)
        char.has_friended_char_or_handle?(potential_friend)
      end
    end
  end
end