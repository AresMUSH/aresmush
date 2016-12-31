module AresMUSH
  module Bbs
    class BbsReplyCmd
      include CommandHandler
      
      attr_accessor :board_name, :num, :reply

      def crack!        
        if (cmd.args =~ /.+\/.+\=.+/)
          cmd.crack_args!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=(?<reply>[^\=]+)/)
          self.board_name = titleize_input(cmd.args.name)
          self.num = trim_input(cmd.args.num)
          self.reply = cmd.args.reply
        elsif (cmd.args =~ /.+\=.+\/.+/)
          cmd.crack_args!( /(?<name>[^\=]+)\=(?<num>[^\=]+)\/(?<reply>[^\=]+)/)
          self.board_name = titleize_input(cmd.args.name)
          self.num = trim_input(cmd.args.num)
          self.reply = cmd.args.reply
        else
          self.reply = cmd.args
        end
      end
      
      def required_args
        {
          args: [ self.reply ],
          help: 'bbs'
        }
      end
      
      def handle
        post = client.program[:last_bbs_post]
        if (!self.board_name && post)
          board = post.bbs_board
          save_reply(board, post)
        else
          if (!self.board_name || !self.num)
            client.emit_failure t('dispatcher.invalid_syntax', :command => 'bbs')
            return
          end
          Bbs.with_a_post(self.board_name, self.num, client, enactor) do |board, post|
            save_reply(board, post)
          end
        end
      end
      
      def save_reply(board, post)
        if (!Bbs.can_write_board?(enactor, board))
          client.emit_failure(t('bbs.cannot_post'))
          return
        end

        reply = BbsReply.create(author: enactor, bbs_post: post, message: self.reply)
        
        post.mark_unread
        Bbs.mark_read_for_player(enactor, post)
        
        Global.client_monitor.emit_all_ooc t('bbs.new_reply', :subject => post.subject, 
        :board => board.name, 
        :reference => post.reference_str,
        :author => enactor_name)
      end
    end
  end
end