module AresMUSH
  module Bbs
    class BbsReplyCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name, :num, :reply

      def initialize
        self.required_args = ['reply']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("reply")
      end
            
      def crack!
        if (cmd.args !~ /.+\/.+\=.+/)
          self.reply = cmd.args
        else
          cmd.crack_args!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<reply>[^\=]+)/)
          self.board_name = titleize_input(cmd.args.name)
          self.num = trim_input(cmd.args.num)
          self.reply = cmd.args.reply
        end
      end
      
      def handle
        post = client.program[:last_bbs_post]
        if (self.board_name.nil? && !post.nil?)
          board = post.bbs_board
          save_reply(board, post)
        else
          if (self.board_name.nil? || self.num.nil?)
            client.emit_failure t('dispatcher.invalid_syntax', :command => 'bbs')
            return
          end
          Bbs.with_a_post(self.board_name, self.num, client) do |board, post|
            save_reply(board, post)
          end
        end
      end
      
      def save_reply(board, post)
        if (!Bbs.can_write_board?(client.char, board))
          client.emit_failure(t('bbs.cannot_post'))
          return
        end

        BbsReply.create(author: client.char, bbs_post: post, message: self.reply)
        post.mark_unread
        Bbs.mark_read_for_player(client.char, post)
        
        Global.client_monitor.emit_all_ooc t('bbs.new_reply', :subject => post.subject, 
        :board => board.name, 
        :reference => post.reference_str,
        :author => client.name)
      end
    end
  end
end