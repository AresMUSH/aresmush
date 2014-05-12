module AresMUSH
  module Bbs
    class BoardListTemplate
      include TemplateFormatters
      
      attr_accessor :boards
      
      def initialize(boards)
        self.boards = boards
      end
    end
    
    class BoardListBbsTemplate
      include TemplateFormatters
      
      def initialize(board, client)
        @board = board
        @client = client
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
        read_status = Bbs.can_read_board?(@client.char, @board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@client.char, @board) ? "w" : "-"
        center("#{read_status}#{write_status}", 5)
      end
      
      def unread_status
        unread_status = @board.has_unread?(@client.char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
      end
    end
  end
end