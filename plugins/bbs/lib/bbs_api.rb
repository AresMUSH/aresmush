module AresMUSH
  module Bbs
    def self.has_unread_bbs?(char)
      BbsBoard.all.each do |b|
        if (b.has_unread?(char))
          return true
        end
      end
      return false
    end
    
    def self.system_post(board, subject, message)
      return if !board
      return if board.blank?
  
      Bbs.post(board, subject, message, Game.master.system_character)
    end
  end
end
