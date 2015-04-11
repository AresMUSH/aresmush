module AresMUSH
  module Bbs
    # Template for the list of all bulletin boards.
    class BoardListTemplate
      include TemplateFormatters
      
      # List of all bulletin boards in order.
      attr_accessor :boards
      
      def initialize(char)
        @char = char
        @boards = BbsBoard.all_sorted
      end
      
      def display
        text = "%l1%r"
        text << "%xh#{t('bbs.boards_list_title')}%xn%r"
        text << "%l2"
        boards.each_with_index do |b, i|
          text << "%R"
          text << board_num(i)
          text << " "
          text << board_unread_status(b)
          text << " "
          text << board_name(b)
          text << " "
          text << board_desc(b)
          text << " "
          text << board_permission(b)
        end
        
        text << "%r%l1"

        text
      end
        
      def board_num(index)
        "#{index+1}".rjust(3)
      end
      
      def board_name(board)
        left(board.name,27)
      end
      
      def board_desc(board)
        left(board.description,34)
      end
      
      # Shows whether the character has read or write permissions
      # to the board. (e.g. rw or r-)
      def board_permission(board)
        read_status = Bbs.can_read_board?(@char, board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@char, board) ? "w" : "-"
        center("#{read_status}#{write_status}", 5)
      end
      
      # Shows the unread marker if there are posts the character hasn't read.
      def board_unread_status(board)
        unread_status = board.has_unread?(@char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
      end
    end
  end
end