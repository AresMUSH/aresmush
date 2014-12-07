module AresMUSH
  class Character
    def has_unread_bbs?
      BbsBoard.all.any? { |b| b.has_unread?(self) }
    end
  end
end