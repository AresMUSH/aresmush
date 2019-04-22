module AresMUSH
  module Forum
    class ForumEditCmd
      include CommandHandler
      
      attr_accessor :category_name, :num, :new_text, :subject

      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args( /(?<name>[^\/]+)\/(?<num>[^\=]+)\=(?<subject>[^\/]+)\/(?<new_text>.+)/)
          self.category_name = titlecase_arg(args.name)
          self.num = trim_arg(args.num)
          self.subject = args.subject
          self.new_text = args.new_text
        else
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.category_name = titlecase_arg(args.arg1)
          self.num = trim_arg(args.arg2)
        end
      end
      
      def required_args        
        [ self.category_name, self.num ]
      end
      
      def handle
        Forum.with_a_post(self.category_name, self.num, client, enactor) do |category, post|
          
          if (!Forum.can_edit_post?(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
            
          if (!self.new_text)
            Utils.grab client, enactor, "forum/edit #{self.category_name}/#{self.num}=#{post.subject}/#{post.message}"
          else
            Forum.edit_post(post, enactor, self.subject, self.new_text)
          end
        end
      end
    end
  end
end