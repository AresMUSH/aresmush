module AresMUSH
  module Bbs
    # Template for the list of all bulletin boards.
    class BoardListTemplate < ErbTemplateRenderer
      
      # List of all bulletin boards in order.
      attr_accessor :boards
      
      def initialize(char)
        @char = char
        @boards = BbsBoard.all_sorted
        super File.dirname(__FILE__) + "/board_list.erb"
      end
      
      def num(index)
        "#{index+1}"
      end        
      
      # Shows whether the character has read or write permissions
      # to the board. (e.g. rw or r-)
      def permission(board)
        read_status = Bbs.can_read_board?(@char, board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@char, board) ? "w" : "-"
        "#{read_status}#{write_status}"
      end
      
      # Shows the unread marker if there are posts the character hasn't read.
      def unread(board)
        board.has_unread?(@char) ? t('bbs.unread_marker') : " "
      end
    end
  end
end