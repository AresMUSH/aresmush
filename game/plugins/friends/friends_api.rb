module AresMUSH
  class Character
    def is_friend?(potential_friend)
      self.has_friended_char_or_handle?(potential_friend)
    end
  end
end