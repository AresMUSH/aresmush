module AresMUSH
  module Bbs
    # The template code for showing the list of bulletin boards.
    class BoardListTemplate
      include TemplateFormatters
      
      # List of all bulletin boards in order.
      # You would typically use this in a loop, such as in the example below.
      # Inside the loop, each board would be referenced as 'b' and its 
      # counter index (0,1,2) as 'i'.
      #   <% boards.each_with_index do |b, i| -%> 
      #       <%= board_num(i) %> <%= board_name(b) %>
      #       <% end %>
      attr_accessor :boards
      
      def initialize(char)
        @char = char
        @boards = BbsBoard.all_sorted
      end
      
      # Board number.
      # Requires a board index counter.  See 'boards' for more info.
      def board_num(index)
        "#{index+1}".rjust(3)
      end
      
      # Board name.
      # Requires a board reference. See 'boards' for more info.
      def board_name(board)
        left(board.name,27)
      end
      
      # Board description.
      # Requires a board reference. See 'boards' for more info.
      def board_desc(board)
        left(board.description,34)
      end
      
      # Shows whether the character has read or write permissions
      # to the board. (e.g. rw or r-)
      # Requires a board reference. See 'boards' for more info.
      def board_permission(board)
        read_status = Bbs.can_read_board?(@char, board) ? "r" : "-"
        write_status = Bbs.can_write_board?(@char, board) ? "w" : "-"
        center("#{read_status}#{write_status}", 5)
      end
      
      # Shows the unread marker if there are posts the character hasn't read.
      # Requires a board reference. See 'boards' for more info.
      def board_unread_status(board)
        unread_status = board.has_unread?(@char) ? t('bbs.unread_marker') : " "
        unread_status = center(unread_status, 5)
      end
    end
  end
end