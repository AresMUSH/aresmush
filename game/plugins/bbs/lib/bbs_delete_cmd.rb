module AresMUSH
  module Bbs
    class BbsDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name, :num
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2)
        self.board_name = titleize_input(cmd.args.arg1)
        self.num = trim_input(cmd.args.arg2)
      end

      def required_args
        {
          args: [ self.board_name, self.num ],
          help: 'bbs'
        }
      end
            
      def handle
        if (self.num =~ /\-/)
          splits = self.num.split("-")
          if (splits.count != 2)
            client.emit_failure t('bbs.invalid_post_number')
            return
          end
          start_post = splits[0].to_i
          end_post = splits[1].to_i
          
          if (start_post <= 0 || end_post <= 0 || start_post > end_post)
            client.emit_failure t('bbs.invalid_post_number')
            return
          end
          posts_to_delete = (start_post..end_post).to_a.reverse
          posts_to_delete.each do |p|
            delete_post(p.to_s)
          end
        else
          delete_post(self.num)
        end
      end
      
      def delete_post(num)
        Bbs.with_a_post(self.board_name, num, client, enactor) do |board, post| 
          
          if (!Bbs.can_edit_post(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
                             
          post.delete
          client.emit_success(t('bbs.post_deleted', :board => board.name, :num => num))
        end
      end
    end
  end
end