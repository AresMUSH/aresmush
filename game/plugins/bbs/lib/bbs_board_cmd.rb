module AresMUSH
  module Bbs
    class BbsBoardCmd
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
        Bbs.with_a_board(self.board_name, client) do |board|  
          template = BoardTemplate.new(board, client)
          client.emit template.render
        end
      end
    end
  end
end