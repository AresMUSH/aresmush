module AresMUSH
  module Bbs
    class BbsCatchupCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :board_name
      
      def crack!
        self.board_name = cmd.args ? titleize_input(cmd.args) : "All"
      end

      def handle
        if (self.board_name == "All")
          BbsBoard.all.each do |b|
            catchup_board(b)
          end
          client.emit_success t('bbs.caught_up_all')
        else
          Bbs.with_a_board(self.board_name, client, enactor) do |board|  
            catchup_board(board)
            client.emit_success t('bbs.caught_up', :board => board.name)
          end
        end
      end
      
      def catchup_board(board)
        board.unread_posts(enactor).each do |p|
          Bbs.mark_read_for_player(enactor, p)
        end
      end
    end
  end
end