module AresMUSH
  module Bbs
    class BbsBoardCmd
      include CommandHandler
      
      attr_accessor :board_name

      def parse_args
        self.board_name = titlecase_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.board_name ],
          help: 'bbs reading'
        }
      end
      
      def handle
        Bbs.with_a_board(self.board_name, client, enactor) do |board|  
          template = BoardTemplate.new(board, enactor)
          client.emit template.render
        end
      end
    end
  end
end