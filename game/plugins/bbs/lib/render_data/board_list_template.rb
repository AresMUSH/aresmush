module AresMUSH
  module Bbs
    class BoardListTemplate
      include TemplateFormatters
      
      attr_accessor :boards
      
      def initialize(char, boards)
        @char = char
        self.boards = boards
      end
    end
    
    class BoardListBoardTemplate
      include TemplateFormatters
      
      def initialize(board, char)
        @board = board
        @char = char
      end
      
      def num(i)
        "#{i+1}".rjust(2)
      end
      
      def name
        left(@board.name,27)
      end
      
      def desc
        left(@board.description,34)
      end
      
      def permission
        read_status = Bbs.can_read_board?(@char, @board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@char, @board) ? "w" : "-"
        center("#{read_status}#{write_status}", 5)
      end
      
      def unread_status
        unread_status = @board.has_unread?(@char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
      end
    end
  end
end