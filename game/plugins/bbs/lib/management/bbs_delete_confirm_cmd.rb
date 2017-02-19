module AresMUSH
  module Bbs
    class BbsDeleteBoardConfirmCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(enactor)
        return nil
      end
      
      def handle
        board = client.program[:delete_bbs]
        
        if (!board)
          client.emit_failure t('bbs.no_delete_in_progress')
          return
        end
        
        Bbs.with_a_board(board.name, client, enactor) do |board|
          board.delete
          client.program.delete(:delete_bbs)          
          client.emit_success t('bbs.board_deleted', :board => board.name)
        end
      end
    end
  end
end
