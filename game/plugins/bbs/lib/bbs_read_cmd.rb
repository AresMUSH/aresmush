module AresMUSH
  module Bbs
    class BbsReadCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name, :num

      def initialize
        self.required_args = ['board_name', 'num']
        self.help_topic = 'bbs'
        super
      end
      
      def crack!
        cmd.crack_args!( /(?<name>[^\=]+)\/(?<num>.+)/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
      end
      
      def handle
        if (self.num.downcase == 'u')
          Global.dispatcher.queue_command(client, Command.new("bbs/new #{self.board_name}"))
          return
        end
        
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post|      

          template = PostTemplate.new(board, post, client)
          client.emit template.render

          Bbs.mark_read_for_player(client.char, post)
          client.program[:last_bbs_post] = post
        end
      end      
    end
  end
end