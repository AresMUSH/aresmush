module AresMUSH
  module Bbs
    class BbsCatchupCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name

      def initialize
        self.required_args = ['board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def crack!
        self.board_name = titleize_input(cmd.args)
      end
      
      def handle
        if (self.board_name == "All")
          BbsBoard.each do |b|
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
        unread_posts = board.bbs_posts.select { |p| p.is_unread?(enactor) }
        unread_posts.each do |p|
          Bbs.mark_read_for_player(enactor, p)
        end
      end
    end
  end
end