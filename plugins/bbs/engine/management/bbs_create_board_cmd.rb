module AresMUSH
  module Bbs
    class BbsCreateBoardCmd
      include CommandHandler
           
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(enactor)
        return nil
      end
      
      def check_board_exists
        return nil if !self.name
        board = BbsBoard.all_sorted.find { |b| b.name.upcase == self.name.upcase }
        return t('bbs.board_already_exists', :name => self.name) if board
        return nil
      end
      
      def handle
        BbsBoard.create(name: self.name, order: BbsBoard.all.count + 1)
        client.emit_success t('bbs.board_created')
      end
    end
  end
end
