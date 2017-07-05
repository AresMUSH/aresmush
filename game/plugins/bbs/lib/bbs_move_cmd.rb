module AresMUSH
  module Bbs
    class BbsMoveCmd
      include CommandHandler
      
      attr_accessor :board_name, :num, :new_board_name
      
      def parse_args
        args = cmd.parse_args( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<new_board>[^\=]+)/)
        self.board_name = titlecase_arg(args.name)
        self.num = trim_arg(args.num)
        self.new_board_name = trim_arg(args.new_board)
      end
      
      def required_args
        {
          args: [ self.board_name, self.num, self.new_board_name ],
          help: 'bbs posting'
        }
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client, enactor) do |board, post|
          if (!Bbs.can_edit_post?(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          Bbs.with_a_board(self.new_board_name, client, enactor) do |new_board|
            post.update(bbs_board: new_board)
            client.emit_success t('bbs.post_moved', :subject => post.subject, :board => new_board.name)
          end
        end
      end
    end
  end
end