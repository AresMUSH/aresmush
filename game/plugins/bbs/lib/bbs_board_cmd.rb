module AresMUSH
  module Bbs
    class BbsBoardCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name

      def initialize(client, cmd, enactor)
        self.required_args = ['board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def crack!
        self.board_name = titleize_input(cmd.args)
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