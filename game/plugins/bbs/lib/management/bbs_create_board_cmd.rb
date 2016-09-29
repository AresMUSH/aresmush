module AresMUSH
  module Bbs
    class BbsCreateBoardCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'bbs'
        super
      end      
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Bbs.can_manage_bbs?(enactor)
        return nil
      end
      
      def check_board_exists
        return nil if self.name.nil?
        board = BbsBoard.all_sorted.find { |b| b.name.upcase == self.name.upcase }
        return t('bbs.board_already_exists', :name => self.name) if !board.nil?
        return nil
      end
      
      def handle
        BbsBoard.create(name: self.name, order: BbsBoard.all.count + 1)
        client.emit_success t('bbs.board_created')
      end
    end
  end
end
