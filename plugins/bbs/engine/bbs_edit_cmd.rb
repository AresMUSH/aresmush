module AresMUSH
  module Bbs
    class BbsEditCmd
      include CommandHandler
      
      attr_accessor :board_name, :num, :new_text, :subject

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args( /(?<name>[^\/]+)\/(?<num>[^\=]+)\=(?<subject>[^\/]+)\/(?<new_text>.+)/)
          self.board_name = titlecase_arg(args.name)
          self.num = trim_arg(args.num)
          self.subject = args.subject
          self.new_text = args.new_text
        else
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.board_name = titlecase_arg(args.arg1)
          self.num = trim_arg(args.arg2)
        end
      end
      
      def required_args        
        [ self.board_name, self.num ]
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client, enactor) do |board, post|
          
          if (!Bbs.can_edit_post?(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
            
          if (!self.new_text)
            Utils.grab client, enactor, "bbs/edit #{self.board_name}/#{self.num}=#{post.subject}/#{post.message}"
          else
            post.update(message: self.new_text)
            post.update(subject: self.subject)
            post.mark_unread
            notification = t('bbs.new_edit', :subject => post.subject, 
              :board => board.name, 
              :reference => post.reference_str,
              :author => enactor_name)
            
            Global.notifier.notify_ooc(:bbs_edited, notification) do |char|
              Bbs.can_read_board?(char, board)
            end
            
            Bbs.mark_read_for_player(enactor, post)
            
          end
        end
      end
    end
  end
end