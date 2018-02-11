module AresMUSH
  module Forum
    class ForumDeleteCmd
      include CommandHandler
      
      attr_accessor :category_name, :num
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.category_name = titlecase_arg(args.arg1)
        self.num = trim_arg(args.arg2)
      end

      def required_args
        [ self.category_name, self.num ]
      end
            
      def handle
        if (self.num =~ /\-/)
          splits = self.num.split("-")
          if (splits.count != 2)
            client.emit_failure t('forum.invalid_post_number')
            return
          end
          start_post = splits[0].to_i
          end_post = splits[1].to_i
          
          if (start_post <= 0 || end_post <= 0 || start_post > end_post)
            client.emit_failure t('forum.invalid_post_number')
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
        Forum.with_a_post(self.category_name, num, client, enactor) do |category, post| 
          
          if (!Forum.can_edit_post?(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
                             
          post.delete
          client.emit_success(t('forum.post_deleted', :category => category.name, :num => num))
        end
      end
    end
  end
end