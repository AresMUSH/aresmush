module AresMUSH
  module Bbs
    class BbsReplyCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name, :num, :reply

      def initialize
        self.required_args = ['board_name', 'num', 'reply']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("reply")
      end
            
      def crack!
        cmd.crack!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=?(?<reply>[^\=]+)?/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
        self.reply = cmd.args.reply
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post|
          
          if (!Bbs.can_write_board?(client.char, board))
            client.emit_failure(t('bbs.cannot_post'))
            return
          end

          date = DateTime.now.strftime("%Y-%m-%d")
          post.message = post.message + "%r%r" + t('bbs.reply', :author => client.char.name, :reply => self.reply, :date => date)
          post.mark_unread
          post.save!
          Global.client_monitor.emit_all t('bbs.new_reply', :subject => post.subject, :board => board.name, :author => client.name)
        end
      end
    end
  end
end