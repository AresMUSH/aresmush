module AresMUSH
  module Bbs
    class BoardListTemplate
      include TemplateFormatters
      
      attr_accessor :boards
      
      def initialize(client)
        self.boards = BbsBoard.all_sorted
        @client = client
      end
      
      def board_num(i)
        "#{i+1}".rjust(2)
      end
      
      def board_name(board)
        left(board.name,27)
      end
      
      def board_desc(board)
        left(board.description,34)
      end
      
      def board_permission(board)
        read_status = Bbs.can_read_board?(@client.char, board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@client.char, board) ? "w" : "-"
        center("#{read_status}#{write_status}", 5)
      end
      
      def board_unread_status(board)
        unread_status = board.has_unread?(@client.char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
      end
    end
  end
end