module AresMUSH
  class Character
    def has_unread_bbs?
      BbsBoard.all.each do |b|
        if (b.has_unread?(self))
          return true
        end
      end
      return false
    end
  end
  
  module Bbs
    module Api
      def self.system_post(configured_board, subject, message)
        Bbs.system_post_to_bbs_if_configured(configured_board, subject, message)
      end
      
      def self.post(board_name, subject, message, author, client = nil)
        Bbs.post(board_name, subject, message, author, client)
      end
    end
  end
end
