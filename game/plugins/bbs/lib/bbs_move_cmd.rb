module AresMUSH
  module Bbs
    class BbsMoveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name, :num, :new_board_name

      def initialize
        self.required_args = ['board_name', 'num', 'new_board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def crack!
        cmd.crack_args!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<new_board>[^\=]+)/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
        self.new_board_name = cmd.args.new_board
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post|
          if (!Bbs.can_edit_post(client.char, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          Bbs.with_a_board(self.new_board_name, client) do |new_board|
            post.bbs_board = new_board
            post.save
            client.emit_success t('bbs.post_moved', :subject => post.subject, :board => new_board.name)
          end
        end
      end
    end
  end
end