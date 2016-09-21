module AresMUSH
  module Bbs
    module Api
      def self.system_post(configured_board, subject, message)
        Bbs.system_post_to_bbs_if_configured(configured_board, subject, message)
      end
      
      def self.post(board_name, subject, message, author, client = nil)
        BBs.post(board_name, subject, message, author, client)
      end
      
      def self.has_unread_bbs?(char)
        char.has_unread_bbs?
      end
    end
  end
end
